package cn.tycoding.cloud.upms.biz.controller;

import cn.hutool.core.lang.Dict;
import cn.tycoding.cloud.common.auth.annotation.Inner;
import cn.tycoding.cloud.common.auth.utils.AuthUtil;
import cn.tycoding.cloud.common.core.api.QueryPage;
import cn.tycoding.cloud.common.core.api.R;
import cn.tycoding.cloud.common.log.annotation.ApiLog;
import cn.tycoding.cloud.common.mybatis.utils.MybatisUtil;
import cn.tycoding.cloud.upms.api.dto.SysUserDTO;
import cn.tycoding.cloud.upms.api.dto.UserInfo;
import cn.tycoding.cloud.upms.api.entity.SysUser;
import cn.tycoding.cloud.upms.biz.service.SysUserService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 用户表(User)表控制层
 *
 * @author tycoding
 * @since 2021/5/21
 */
@RestController
@RequiredArgsConstructor
@RequestMapping("/user")
@Api(value = "用户表接口", tags = "用户表接口")
public class SysUserController {

    private final SysUserService sysUserService;

    @Inner
    @GetMapping("/info/{username}")
    @ApiOperation(value = "根据用户名获取用户信息")
    public R<UserInfo> info(@PathVariable String username) {
        SysUser user = sysUserService.findByName(username);
        if (user == null) {
            return R.fail("获取用户信息失败");
        }
        return R.ok(sysUserService.info(user));
    }

    @GetMapping("/info")
    @ApiOperation(value = "获取当前用户信息")
    public R<UserInfo> info() {
        SysUser user = sysUserService.findByName(AuthUtil.getUsername());
        if (user == null) {
            return R.fail("获取用户信息失败");
        }
        user.setPassword(null);
        return R.ok(sysUserService.info(user));
    }

    @GetMapping("/checkName")
    @ApiOperation(value = "校验名称是否已存在")
    public R<Boolean> checkName(SysUserDTO sysUser) {
        return R.ok(sysUserService.checkName(sysUser));
    }

    @GetMapping("/list")
    @ApiOperation(value = "条件查询")
    public R<List<SysUser>> list(SysUser sysUser) {
        return R.ok(sysUserService.list(sysUser));
    }

    @GetMapping("/page")
    @ApiOperation(value = "分页、条件查询")
    public R<Dict> page(SysUserDTO user, QueryPage queryPage) {
        return R.ok(MybatisUtil.getData(sysUserService.page(user, queryPage)));
    }

    @GetMapping("/{id}")
    @ApiOperation(value = "根据ID查询")
    public R<SysUserDTO> findById(@PathVariable Long id) {
        return R.ok(sysUserService.findById(id));
    }

    @PostMapping
    @ApiLog("新增用户")
    @ApiOperation(value = "新增用户")
    @PreAuthorize("@auth.hasAuth('upms:user:add')")
    public R<SysUser> add(@RequestBody SysUserDTO user) {
        sysUserService.add(user);
        return R.ok();
    }

    @PutMapping
    @ApiLog("修改用户")
    @ApiOperation(value = "修改用户")
    @PreAuthorize("@auth.hasAuth('upms:user:update')")
    public R update(@RequestBody SysUserDTO user) {
        sysUserService.update(user);
        return R.ok();
    }

    @DeleteMapping("/{id}")
    @ApiLog("删除用户")
    @ApiOperation(value = "删除用户")
    @PreAuthorize("@auth.hasAuth('upms:user:delete')")
    public R delete(@PathVariable Long id) {
        SysUser user = sysUserService.getById(id);
        if (user != null) {
            sysUserService.delete(id, user.getUsername());
        }
        return R.ok();
    }

    @GetMapping("/reset")
    @ApiLog("重置密码")
    @ApiOperation(value = "重置密码")
    @PreAuthorize("@auth.hasAuth('upms:user:reset')")
    public R reset(@RequestParam Long id, String password) {
        SysUser user = sysUserService.getById(id);
        if (user != null) {
            sysUserService.reset(id, password, user.getUsername());
        }
        return R.ok();
    }
}
