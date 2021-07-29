package cn.tycoding.cloud.common.auth.props;

import cn.hutool.core.util.ReUtil;
import cn.tycoding.cloud.common.auth.annotation.Inner;
import lombok.Data;
import org.springframework.beans.BeansException;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.core.annotation.AnnotationUtils;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.mvc.method.RequestMappingInfo;
import org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerMapping;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.regex.Pattern;

/**
 * Spring Security 白名单配置
 *
 * @author tycoding
 * @since 2021/4/21
 */
@Data
@ConfigurationProperties("tumo-cloud.auth")
public class AuthProperties implements InitializingBean, ApplicationContextAware {

    /**
     * 接口白名单
     */
    private List<String> skipUrl = new ArrayList();

    /**
     * 是否开启演示环境
     */
    private Boolean isDemoEnv;

    private ApplicationContext applicationContext;

    /**
     * 初始化Bean时，拿到接口中所有添加 @Link 注解的方法或类下的接口
     * 将接口过滤并添加到当前的 skipUrl 白名单中，最后会在 ResourceServerConfig 中将白名单接口添加到 HttpSecurity 中
     */
    @Override
    public void afterPropertiesSet() {
        RequestMappingHandlerMapping mapping = applicationContext.getBean(RequestMappingHandlerMapping.class);
        Map<RequestMappingInfo, HandlerMethod> handlerMethods = mapping.getHandlerMethods();

        Pattern pattern = Pattern.compile("\\{(.*?)\\}");
        handlerMethods.keySet().forEach(info -> {
            HandlerMethod handlerMethod = handlerMethods.get(info);

            // 获取Inner注解标识的方法
            Inner method = AnnotationUtils.findAnnotation(handlerMethod.getMethod(), Inner.class);
            Optional.ofNullable(method).ifPresent(inner -> info.getPatternsCondition().getPatterns().forEach(url -> {
                // 过滤接口字符串，"/user/{username}" ——> "/user/*"
                skipUrl.add(ReUtil.replaceAll(url, pattern, "*"));
            }));

            // 获取Inner注解标识的类
            Inner clazz = AnnotationUtils.findAnnotation(handlerMethod.getBeanType(), Inner.class);
            Optional.ofNullable(clazz).ifPresent(inner -> info.getPatternsCondition().getPatterns().forEach(url -> {
                skipUrl.add(ReUtil.replaceAll(url, pattern, "*"));
            }));
        });
    }

    @Override
    public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
        this.applicationContext = applicationContext;
    }
}
