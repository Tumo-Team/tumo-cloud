package cn.tycoding.cloud.upms.biz.controller;

import cn.hutool.core.lang.Dict;
import cn.tycoding.cloud.common.core.api.QueryPage;
import cn.tycoding.cloud.common.core.api.R;
import cn.tycoding.cloud.common.feign.constants.FeignConstant;
import cn.tycoding.cloud.upms.api.feign.RemoteTokenService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

/**
 * 令牌信息接口
 *
 * @author tycoding
 * @since 2021/7/30
 */
@RestController
@RequiredArgsConstructor
@RequestMapping("/token")
@Api(value = "令牌信息接口", tags = "令牌信息接口")
public class TokenController {

    private final RemoteTokenService tokenService;

    @GetMapping("/page")
    @ApiOperation(value = "获取令牌列表", notes = "获取令牌列表")
    public R<Dict> tokenPage(QueryPage queryPage) {
        return tokenService.tokenPage(FeignConstant.INNER, queryPage);
    }

    @DeleteMapping("/{token}")
    @ApiOperation(value = "删除令牌", notes = "删除令牌")
    public R tokenDel(@PathVariable String token) {
        return tokenService.tokenDel(FeignConstant.INNER, token);
    }

}
