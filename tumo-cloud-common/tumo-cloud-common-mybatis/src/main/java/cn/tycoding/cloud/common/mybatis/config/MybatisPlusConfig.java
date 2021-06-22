package cn.tycoding.cloud.common.mybatis.config;

import cn.tycoding.cloud.common.mybatis.intercept.SqlLogInterceptor;
import com.baomidou.mybatisplus.extension.plugins.PaginationInterceptor;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * MybatisPlus插件配置
 *
 * @author tycoding
 * @since 2021/5/21
 */
@Configuration
public class MybatisPlusConfig {

    /**
     * 分页插件
     */
    @Bean
    public PaginationInterceptor paginationInterceptor() {
        return new PaginationInterceptor();
    }

    /**
     * SQL 日志打印
     */
    @Bean
    @ConditionalOnProperty(value = {"tumo-cloud.mybatis.enable"}, matchIfMissing = true)
    public SqlLogInterceptor sqlLogInterceptor() {
        return new SqlLogInterceptor();
    }
}