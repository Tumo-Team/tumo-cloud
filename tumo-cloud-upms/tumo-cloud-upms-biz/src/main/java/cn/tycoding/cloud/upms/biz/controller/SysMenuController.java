package cn.tycoding.cloud.upms.biz.controller;

import cn.tycoding.cloud.common.auth.utils.AuthUtil;
import cn.tycoding.cloud.common.core.api.R;
import cn.tycoding.cloud.common.log.annotation.ApiLog;
import cn.tycoding.cloud.upms.api.dto.MenuTree;
import cn.tycoding.cloud.upms.api.entity.SysMenu;
import cn.tycoding.cloud.upms.biz.service.SysMenuService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 菜单表(Menu)表控制层
 *
 * @author tycoding
 * @since 2021/5/21
 */
@RestController
@RequiredArgsConstructor
@RequestMapping("/menu")
@Api(value = "菜单表接口", tags = "菜单表接口")
public class SysMenuController {

    private final SysMenuService sysMenuService;

    @GetMapping("/tree")
    @ApiOperation(value = "获取菜单表数据", notes = "获取菜单表中所有数据")
    public R<List<MenuTree<SysMenu>>> tree(SysMenu sysMenu) {
        return R.ok(sysMenuService.tree(sysMenu));
    }

    @GetMapping("/build")
    @ApiOperation(value = "加载左侧菜单", notes = "根据用户角色获取允许访问的菜单")
    public R<List<MenuTree<SysMenu>>> build() {
        return R.ok(sysMenuService.build(AuthUtil.getUserId()));
    }

    @GetMapping("/list")
    @ApiOperation(value = "条件查询")
    public R<List<SysMenu>> list(SysMenu sysMenu) {
        return R.ok(sysMenuService.list(sysMenu));
    }

    @GetMapping("/{id}")
    @ApiOperation(value = "根据ID查询")
    public R<SysMenu> findById(@PathVariable Long id) {
        return R.ok(sysMenuService.getById(id));
    }

    @PostMapping
    @ApiLog("新增菜单")
    @ApiOperation(value = "新增菜单")
    @PreAuthorize("@auth.hasAuth('upms:menu:add')")
    public R add(@RequestBody SysMenu sysMenu) {
        sysMenuService.add(sysMenu);
        return R.ok();
    }

    @PutMapping
    @ApiLog("修改菜单")
    @ApiOperation(value = "修改菜单")
    @PreAuthorize("@auth.hasAuth('upms:menu:update')")
    public R update(@RequestBody SysMenu sysMenu) {
        sysMenuService.update(sysMenu);
        return R.ok();
    }

    @DeleteMapping("/{id}")
    @ApiLog("删除菜单")
    @ApiOperation(value = "删除菜单")
    @PreAuthorize("@auth.hasAuth('upms:menu:delete')")
    public R delete(@PathVariable Long id) {
        sysMenuService.delete(id);
        return R.ok();
    }
}
