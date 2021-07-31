package cn.tycoding.cloud.upms.api.feign;

import cn.hutool.core.lang.Dict;
import cn.tycoding.cloud.common.core.api.QueryPage;
import cn.tycoding.cloud.common.core.api.R;
import cn.tycoding.cloud.common.feign.constants.FeignConstant;
import cn.tycoding.cloud.common.feign.constants.ServiceNameConstant;
import cn.tycoding.cloud.upms.api.feign.fallback.RemoteTokenServiceFallbackImpl;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestHeader;

/**
 * Feign远程服务接口，对应Auth模块接口
 *
 * @author tycoding
 * @since 2021/6/22
 */
@FeignClient(value = ServiceNameConstant.AUTH_SERVICE, fallback = RemoteTokenServiceFallbackImpl.class)
public interface RemoteTokenService {

    /**
     * 获取系统中的Token令牌列表
     *
     * @param innerKey  内部接口标识
     * @param queryPage 分页信息
     */
    @GetMapping("/token/page")
    R<Dict> tokenPage(@RequestHeader(FeignConstant.INNER_KEY) String innerKey, QueryPage queryPage);

    /**
     * 强制下线指定Token令牌
     *
     * @param token    令牌ID
     * @param innerKey 内部接口标识
     */
    @DeleteMapping("/token/{token}")
    R tokenDel(@RequestHeader(FeignConstant.INNER_KEY) String innerKey, @PathVariable("token") String token);
}
