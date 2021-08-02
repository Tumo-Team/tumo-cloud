package cn.tycoding.cloud.upms.api.feign.fallback;

import cn.hutool.core.lang.Dict;
import cn.tycoding.cloud.common.core.api.R;
import cn.tycoding.cloud.upms.api.feign.RemoteTokenService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

/**
 * @author tycoding
 * @date 2020/7/13
 */
@Slf4j
@Service
public class RemoteTokenServiceFallbackImpl implements RemoteTokenService {

    @Override
    public R<Dict> tokenPage(String innerKey, int page, int limit) {
        log.error("获取令牌列表失败...");
        return null;
    }

    @Override
    public R tokenDel(String innerKey, String token) {
        log.error("删除令牌失败...");
        return null;
    }
}
