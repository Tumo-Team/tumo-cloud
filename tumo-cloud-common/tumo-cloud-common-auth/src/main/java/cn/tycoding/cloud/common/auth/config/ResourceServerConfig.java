package cn.tycoding.cloud.common.auth.config;

import cn.tycoding.cloud.common.auth.component.ResourceAuthExceptionEntryPoint;
import cn.tycoding.cloud.common.auth.props.AuthProperties;
import cn.tycoding.cloud.common.core.constants.CacheConstant;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Bean;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.oauth2.config.annotation.web.configuration.ResourceServerConfigurerAdapter;
import org.springframework.security.oauth2.config.annotation.web.configurers.ResourceServerSecurityConfigurer;
import org.springframework.security.oauth2.provider.token.TokenStore;
import org.springframework.security.oauth2.provider.token.store.redis.RedisTokenStore;

/**
 * 资源服务器配置
 *
 * @author tycoding
 * @since 2021/2/25
 */
@Slf4j
@RequiredArgsConstructor
public class ResourceServerConfig extends ResourceServerConfigurerAdapter {
    private final String[] swagger_ignores = new String[]{"/swagger-ui.html", "/doc.html/**", "/swagger-ui/**", "/swagger-resources/**", "/v2/api-docs", "/v3/api-docs", "/webjars/**"};

    private final AuthProperties authProperties;
    private final RedisConnectionFactory redisConnectionFactory;
    private final ResourceAuthExceptionEntryPoint resourceAuthExceptionEntryPoint;

    /**
     * 同授权服务器 AuthorizationServerConfig#tokenStore() 配置相同
     * 测试中发现{@link org.springframework.security.oauth2.provider.token.DefaultTokenServices#loadAuthentication(String)}
     * 中还是从InMemoryTokenStore中拿数据，导致资源服务接口鉴权都是401。这里手动加上配置即可。
     * 但实际上一些项目中并没有在资源服务器中配置，待分析
     */
    @Bean
    public TokenStore tokenStore() {
        RedisTokenStore tokenStore = new RedisTokenStore(redisConnectionFactory);
        tokenStore.setPrefix(CacheConstant.OAUTH_PREFIX);
        return tokenStore;
    }

    @Override
    public void configure(ResourceServerSecurityConfigurer resources) throws Exception {
        resources.authenticationEntryPoint(resourceAuthExceptionEntryPoint);
    }

    @Override
    public void configure(HttpSecurity http) throws Exception {
        http
                .authorizeRequests()
                .antMatchers(HttpMethod.GET, swagger_ignores)
                .permitAll()

                .antMatchers(authProperties.getSkipUrl().toArray(new String[0]))
                .permitAll()

                .anyRequest()
                .authenticated()

                .and()
                .csrf().disable();
    }
}
