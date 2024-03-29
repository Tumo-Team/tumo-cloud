package cn.tycoding.cloud.upms.biz.controller;

import cn.hutool.core.lang.tree.Tree;
import cn.tycoding.cloud.common.core.api.R;
import cn.tycoding.cloud.common.log.annotation.ApiLog;
import cn.tycoding.cloud.upms.api.entity.SysDept;
import cn.tycoding.cloud.upms.biz.service.SysDeptService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 部门表(Dept)表控制层
 *
 * @author tycoding
 * @since 2021/5/21
 */
@RestController
@RequiredArgsConstructor
@RequestMapping("/dept")
@Api(value = "部门表接口", tags = "部门表接口")
public class SysDeptController {

    private final SysDeptService sysDeptService;

    @GetMapping("/list")
    @ApiOperation(value = "条件查询")
    public R<List<SysDept>> list(SysDept sysDept) {
        return R.ok(sysDeptService.list(sysDept));
    }

    @GetMapping("/tree")
    @ApiOperation(value = "获取部门Tree")
    public R<List<Tree<Object>>> tree() {
        return R.ok(sysDeptService.tree());
    }

    @GetMapping("/{id}")
    @ApiOperation(value = "根据ID查询")
    public R<SysDept> findById(@PathVariable Long id) {
        return R.ok(sysDeptService.getById(id));
    }

    @PostMapping
    @ApiLog("新增部门")
    @ApiOperation(value = "新增部门")
    @PreAuthorize("@auth.hasAuth('upms:dept:add')")
    public R add(@RequestBody SysDept sysDept) {
        sysDept.setParentId(sysDept.getParentId() == null ? 0L : sysDept.getParentId());
        sysDeptService.save(sysDept);
        return R.ok();
    }

    @PutMapping
    @ApiLog("修改部门")
    @ApiOperation(value = "修改部门")
    @PreAuthorize("@auth.hasAuth('upms:dept:update')")
    public R update(@RequestBody SysDept sysDept) {
        sysDept.setParentId(sysDept.getParentId() == null ? 0L : sysDept.getParentId());
        sysDeptService.updateById(sysDept);
        return R.ok();
    }

    @DeleteMapping("/{id}")
    @ApiLog("删除部门")
    @ApiOperation(value = "删除部门")
    @PreAuthorize("@auth.hasAuth('upms:dept:delete')")
    public R delete(@PathVariable Long id) {
        sysDeptService.delete(id);
        return R.ok();
    }
}
