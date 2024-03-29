package cn.tycoding.cloud.auth.endpoint;

import cn.hutool.captcha.CaptchaUtil;
import cn.hutool.captcha.CircleCaptcha;
import cn.hutool.core.lang.Dict;
import cn.tycoding.cloud.common.auth.annotation.Inner;
import cn.tycoding.cloud.common.auth.dto.TumoUser;
import cn.tycoding.cloud.common.auth.utils.AuthUtil;
import cn.tycoding.cloud.common.core.api.R;
import cn.tycoding.cloud.common.core.constants.CacheConstant;
import cn.tycoding.cloud.common.core.constants.CaptchaConstant;
import cn.tycoding.cloud.common.mybatis.utils.MybatisUtil;
import cn.tycoding.cloud.common.redis.utils.RedisUtil;
import cn.tycoding.cloud.common.redis.utils.TokenInfo;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.RequiredArgsConstructor;
import org.apache.commons.lang3.StringUtils;
import org.springframework.cache.CacheManager;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.http.HttpHeaders;
import org.springframework.security.oauth2.common.DefaultOAuth2AccessToken;
import org.springframework.security.oauth2.common.OAuth2AccessToken;
import org.springframework.security.oauth2.provider.OAuth2Authentication;
import org.springframework.security.oauth2.provider.token.TokenStore;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import java.time.Duration;
import java.util.ArrayList;
import java.util.List;

/**
 * 自定义授权相关的接口
 *
 * @author tycoding
 * @since 2021/5/21
 */
@RestController
@RequestMapping("/token")
@RequiredArgsConstructor
@Api(value = "自定义Token端点", tags = "自定义Token端点")
public class AuthTokenEndpoint {

    private final TokenStore tokenStore;
    private final RedisTemplate redisTemplate;
    private final CacheManager cacheManager;

    /**
     * 自定义授权登录页面
     * SpringSecurity默认formLogin：
     *
     * @see org.springframework.security.web.authentication.ui.DefaultLoginPageGeneratingFilter
     */
    @GetMapping("/login")
    @ApiOperation(value = "自定义授权登录页面")
    public ModelAndView login(ModelAndView modelAndView, String error) {
        modelAndView.setViewName("login");
        modelAndView.addObject("error", error);
        return modelAndView;
    }

    /**
     * 获取验证码
     */
    @GetMapping("/captcha")
    @ApiOperation(value = "获取验证码")
    public R<Dict> getCaptcha() {
        CircleCaptcha captcha = CaptchaUtil.createCircleCaptcha(CaptchaConstant.CAPTCHA_WIDTH, CaptchaConstant.CAPTCHA_HEIGHT, CaptchaConstant.CAPTCHA_COUNT, CaptchaConstant.CAPTCHA_CIRCLE_COUNT);
        String code = captcha.getCode().toLowerCase();
        String key = RedisUtil.getKey();
        redisTemplate.opsForValue().set(CacheConstant.CAPTCHA_PREFIX + key, code, Duration.ofMinutes(CaptchaConstant.CAPTCHA_TIMEOUT));
        return R.ok(Dict.create().set("key", key).set("image", captcha.getImageBase64()));
    }

    /**
     * 注销登录并清除Token
     */
    @DeleteMapping("/logout")
    @ApiOperation(value = "注销接口")
    public R logout(@RequestHeader(value = HttpHeaders.AUTHORIZATION, required = false) String token) {
        return clear(AuthUtil.getToken(token));
    }

    private R clear(String token) {
        OAuth2AccessToken accessToken = tokenStore.readAccessToken(token);
        if (accessToken == null || StringUtils.isEmpty(accessToken.getValue())) {
            return R.ok("无法获取Token，清除缓存失效");
        }
        OAuth2Authentication authentication = tokenStore.readAuthentication(accessToken);
        // 清空access_token
        tokenStore.removeAccessToken(accessToken);
        // 清空refresh_token
        tokenStore.removeRefreshToken(accessToken.getRefreshToken());

        // 清空User Details
        cacheManager.getCache(CacheConstant.USER_DETAIL_KEY).evict(authentication.getName());
        // 清空Menu Details
        TumoUser principal = (TumoUser) authentication.getPrincipal();
        cacheManager.getCache(CacheConstant.MENU_DETAIL_KEY).evict(principal.getId());
        return R.ok();
    }

    /**
     * 强制下线
     */
    @Inner
    @DeleteMapping("/{token}")
    @ApiOperation(value = "强制下线")
    public R tokenDel(@PathVariable String token) {
        clear(token);
        return R.ok();
    }

    /**
     * 分页获取在线Token
     */
    @Inner
    @GetMapping("/page")
    @ApiOperation(value = "获取令牌")
    public R<Dict> tokenPage(@RequestParam("page") int page, @RequestParam("limit") int limit) {
        String key = String.format("%sauth_to_access:*", CacheConstant.OAUTH_PREFIX);
        List<String> keysPage = RedisUtil.getKeysPage(redisTemplate, key, 1, 10);
        List<DefaultOAuth2AccessToken> list = redisTemplate.opsForValue().multiGet(keysPage);
        List<TokenInfo> tokenInfoList = new ArrayList<>();
        list.forEach(accessToken -> {
            OAuth2Authentication authentication = tokenStore.readAuthentication(accessToken.getValue());
            TokenInfo tokenInfo = new TokenInfo()
                    .setValue(accessToken.getValue())
                    .setRefreshToken(accessToken.getRefreshToken().getValue())
                    .setTokenType(accessToken.getTokenType())
                    .setExpiration(accessToken.getExpiration())
                    .setScope(accessToken.getScope())
                    .setUsername(authentication.getName());
            tokenInfoList.add(tokenInfo);
        });

        int total = redisTemplate.keys(key).size();
        Page iPage = new Page(page, limit, total);
        iPage.setRecords(tokenInfoList);
        return R.ok(MybatisUtil.getData(iPage));
    }
}
