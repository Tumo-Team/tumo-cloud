package cn.tycoding.cloud.upms.biz.controller;

import cn.hutool.core.lang.Dict;
import cn.tycoding.cloud.common.core.api.QueryPage;
import cn.tycoding.cloud.common.core.api.R;
import cn.tycoding.cloud.common.mybatis.utils.MybatisUtil;
import cn.tycoding.cloud.upms.api.entity.SysLog;
import cn.tycoding.cloud.upms.biz.service.SysLogService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

/**
 * 系统日志表(Log)表控制层
 *
 * @author tycoding
 * @since 2021/5/21
 */
@RestController
@RequiredArgsConstructor
@Api(value = "系统日志表管理接口", tags = "系统日志表管理接口")
@RequestMapping("/log")
public class SysLogController {

    private final SysLogService sysLogService;

    @GetMapping("/page")
    @ApiOperation(value = "分页查询")
    public R<Dict> list(SysLog sysLog, QueryPage queryPage) {
        return R.ok(MybatisUtil.getData(sysLogService.list(sysLog, queryPage)));
    }

    @GetMapping("/{id}")
    @ApiOperation(value = "根据ID查询")
    public R<SysLog> findById(@PathVariable Long id) {
        return R.ok(sysLogService.getById(id));
    }

    @DeleteMapping("/{id}")
    @ApiOperation(value = "根据ID删除")
    @PreAuthorize("@auth.hasAuth('system:log:delete')")
    public R delete(@PathVariable Long id) {
        sysLogService.delete(id);
        return R.ok();
    }
}
