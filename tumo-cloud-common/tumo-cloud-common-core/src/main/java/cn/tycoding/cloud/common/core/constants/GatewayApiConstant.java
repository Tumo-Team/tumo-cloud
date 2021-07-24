package cn.tycoding.cloud.common.core.constants;

/**
 * Gateway路由网关 配置的服务路由地址
 *
 * @author tycoding
 * @since 2021/7/24
 */
public interface GatewayApiConstant {

    /**
     * 网关路由前缀
     */
    String API_PREFIX = "/tumo-cloud";

    /**
     * Auth 服务路由前缀
     */
    String AUTH_PREFIX = "/auth";

    /**
     * Upms 服务路由前缀
     */
    String UPMS_PREFIX = "/upms";

    /**
     * Swagger 调用的授权网关接口
     */
    String AUTH_TOKEN_PREFIX = API_PREFIX + AUTH_PREFIX + ApiConstant.API_OAUTH_TOKEN;
}
