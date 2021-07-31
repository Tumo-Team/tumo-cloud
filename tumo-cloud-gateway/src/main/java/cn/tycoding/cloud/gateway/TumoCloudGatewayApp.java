package cn.tycoding.cloud.gateway;

import cn.tycoding.cloud.gateway.handler.ExtendErrorAttributes;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.boot.autoconfigure.condition.SearchStrategy;
import org.springframework.boot.web.reactive.error.ErrorAttributes;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.context.annotation.Bean;

/**
 * 网关路由
 *
 * @author tycoding
 * @since 2021/2/27
 */
@SpringBootApplication
@EnableDiscoveryClient
public class TumoCloudGatewayApp {

    public static void main(String[] args) {
        SpringApplication.run(TumoCloudGatewayApp.class, args);
    }

    /**
     * 注册自定义异常处理对象
     */
    @Bean
    @ConditionalOnMissingBean(
            value = {ErrorAttributes.class},
            search = SearchStrategy.CURRENT
    )
    public ExtendErrorAttributes errorAttributes() {
        return new ExtendErrorAttributes();
    }
}
