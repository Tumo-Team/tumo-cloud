package cn.tycoding.cloud.upms.biz.service;

import cn.tycoding.cloud.common.core.api.QueryPage;
import cn.tycoding.cloud.upms.api.dto.SysUserDTO;
import cn.tycoding.cloud.upms.api.dto.UserInfo;
import cn.tycoding.cloud.upms.api.entity.SysUser;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.IService;

import java.util.List;

/**
 * 用户表(User)表服务接口
 *
 * @author tycoding
 * @since 2021/5/21
 */
public interface SysUserService extends IService<SysUser> {

    /**
     * 根据用户名查询
     */
    SysUser findByName(String username);

    /**
     * 根据ID查询
     */
    SysUserDTO findById(Long userId);

    /**
     * 根据用户名封装：用户信息、角色、部门、权限
     */
    UserInfo info(SysUser sysUser);

    /**
     * 条件查询
     */
    List<SysUser> list(SysUser sysUser);

    /**
     * 分页、条件查询
     */
    IPage<SysUserDTO> page(SysUserDTO user, QueryPage queryPage);

    /**
     * 校验用户名是否存在
     */
    boolean checkName(SysUserDTO sysUser);

    /**
     * 新增
     */
    void add(SysUserDTO user);

    /**
     * 修改
     */
    void update(SysUserDTO user);

    /**
     * 删除
     */
    void delete(Long id, String username);

    /**
     * 重置密码
     */
    void reset(Long id, String password, String username);
}
