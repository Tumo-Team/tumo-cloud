package cn.tycoding.cloud.auth.config;

import cn.tycoding.cloud.auth.filter.CaptchaFilter;
import cn.tycoding.cloud.auth.handler.FormFailureHandler;
import cn.tycoding.cloud.common.auth.props.AuthProperties;
import lombok.RequiredArgsConstructor;
import lombok.SneakyThrows;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

/**
 * SpringSecurity配置
 *
 * @author tycoding
 * @since 2021/2/25
 */
@Configuration
@RequiredArgsConstructor
public class WebSecurityConfig extends WebSecurityConfigurerAdapter {
    private final String[] swagger_ignores = new String[]{"/swagger-ui.html", "/doc.html/**", "/swagger-ui/**", "/swagger-resources/**", "/v2/api-docs", "/v3/api-docs", "/webjars/**"};

    private final CaptchaFilter captchaFilter;
    private final AuthProperties authProperties;

    @Bean
    public BCryptPasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    @Override
    @SneakyThrows
    public AuthenticationManager authenticationManager() {
        return super.authenticationManager();
    }

    @Bean
    public AuthenticationFailureHandler authenticationFailureHandler() {
        return new FormFailureHandler();
    }

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
//                .formLogin()
//                .loginPage("/token/login")
//                .loginProcessingUrl("/token/form")
//                .failureHandler(authenticationFailureHandler())

//                .and()
                .logout()
                .deleteCookies("JSESSIONID")

                .and()
                .authorizeRequests()
                .antMatchers(swagger_ignores)
                .permitAll()

                .antMatchers("/token/**", "/actuator/**")
                .permitAll()

                .antMatchers(authProperties.getSkipUrl().toArray(new String[0]))
                .permitAll()

                .anyRequest()
                .authenticated()

                .and()
                .csrf().disable();

        http.addFilterBefore(captchaFilter, UsernamePasswordAuthenticationFilter.class);
    }
}
