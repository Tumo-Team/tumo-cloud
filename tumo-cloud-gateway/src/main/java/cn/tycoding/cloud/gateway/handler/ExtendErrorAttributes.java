package cn.tycoding.cloud.gateway.handler;

import org.springframework.boot.web.error.ErrorAttributeOptions;
import org.springframework.boot.web.error.ErrorAttributeOptions.Include;
import org.springframework.boot.web.reactive.error.DefaultErrorAttributes;
import org.springframework.boot.web.reactive.error.ErrorAttributes;
import org.springframework.core.annotation.MergedAnnotation;
import org.springframework.core.annotation.MergedAnnotations;
import org.springframework.core.annotation.MergedAnnotations.SearchStrategy;
import org.springframework.http.HttpStatus;
import org.springframework.util.StringUtils;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.reactive.function.server.ServerRequest;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.server.ServerWebExchange;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Optional;

/**
 * 自定义Gateway异常响应格式
 * 直接copy {@link DefaultErrorAttributes} ，修改其异常响应格式，然后覆盖注入Bean即可
 *
 * @author tycoding
 * @since 2021/8/1
 */
public class ExtendErrorAttributes implements ErrorAttributes {
    private static final String ERROR_INTERNAL_ATTRIBUTE = DefaultErrorAttributes.class.getName() + ".ERROR";

    public ExtendErrorAttributes() {
    }

    @Override
    public Map<String, Object> getErrorAttributes(ServerRequest request, ErrorAttributeOptions options) {
        return this.getErrorAttributes(request, options.isIncluded(Include.STACK_TRACE));
    }

    @Override
    public Throwable getError(ServerRequest request) {
        Optional<Object> error = request.attribute(ERROR_INTERNAL_ATTRIBUTE);
        error.ifPresent((value) -> {
            request.attributes().putIfAbsent(ErrorAttributes.ERROR_ATTRIBUTE, value);
        });
        return (Throwable) error.orElseThrow(() -> {
            return new IllegalStateException("Missing exception attribute in ServerWebExchange");
        });
    }

    @Override
    public void storeErrorInformation(Throwable error, ServerWebExchange exchange) {
        exchange.getAttributes().putIfAbsent(ERROR_INTERNAL_ATTRIBUTE, error);
    }

    private Map<String, Object> getErrorAttributes(ServerRequest request, boolean includeStackTrace) {
        Map<String, Object> errorAttributes = new LinkedHashMap();
        Throwable error = this.getError(request);
        MergedAnnotation<ResponseStatus> responseStatusAnnotation = MergedAnnotations.from(error.getClass(), SearchStrategy.TYPE_HIERARCHY).get(ResponseStatus.class);
        HttpStatus errorStatus = determineHttpStatus(error, responseStatusAnnotation);
        // 请求响应状态码，必须定义，否则会空指针
        errorAttributes.put("status", errorStatus.value());
        errorAttributes.put("code", errorStatus.value());
        errorAttributes.put("msg", this.determineMessage(error, responseStatusAnnotation));
        errorAttributes.put("data", null);
        this.handleException(errorAttributes, this.determineException(error), includeStackTrace);
        return errorAttributes;
    }


    private HttpStatus determineHttpStatus(Throwable error, MergedAnnotation<ResponseStatus> responseStatusAnnotation) {
        return error instanceof ResponseStatusException ? ((ResponseStatusException) error).getStatus() : (HttpStatus) responseStatusAnnotation.getValue("code", HttpStatus.class).orElse(HttpStatus.INTERNAL_SERVER_ERROR);
    }

    private Throwable determineException(Throwable error) {
        if (error instanceof ResponseStatusException) {
            return error.getCause() != null ? error.getCause() : error;
        } else {
            return error;
        }
    }

    private String determineMessage(Throwable error, MergedAnnotation<ResponseStatus> responseStatusAnnotation) {
        if (error instanceof BindingResult) {
            return error.getMessage();
        } else if (error instanceof ResponseStatusException) {
            return ((ResponseStatusException) error).getReason();
        } else {
            String reason = (String) responseStatusAnnotation.getValue("reason", String.class).orElse("");
            if (StringUtils.hasText(reason)) {
                return reason;
            } else {
                return error.getMessage() != null ? error.getMessage() : "";
            }
        }
    }

    private void handleException(Map<String, Object> errorAttributes, Throwable error, boolean includeStackTrace) {
        errorAttributes.put("exception", error.getClass().getName());
        if (includeStackTrace) {
            this.addStackTrace(errorAttributes, error);
        }

        if (error instanceof BindingResult) {
            BindingResult result = (BindingResult) error;
            if (result.hasErrors()) {
                errorAttributes.put("errors", result.getAllErrors());
            }
        }
    }

    private void addStackTrace(Map<String, Object> errorAttributes, Throwable error) {
        StringWriter stackTrace = new StringWriter();
        error.printStackTrace(new PrintWriter(stackTrace));
        stackTrace.flush();
        errorAttributes.put("trace", stackTrace.toString());
    }
}
