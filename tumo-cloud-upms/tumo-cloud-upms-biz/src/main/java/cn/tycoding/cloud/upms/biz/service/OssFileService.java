package cn.tycoding.cloud.upms.biz.service;

import cn.tycoding.cloud.common.core.api.QueryPage;
import cn.tycoding.cloud.upms.api.entity.OssFile;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.IService;

/**
 * 资源文件表（OssFile）服务接口
 *
 * @author tycoding
 * @since 2021/5/20
 */
public interface OssFileService extends IService<OssFile> {

    /**
     * 分页查询
     */
    IPage<OssFile> page(OssFile ossFile, QueryPage queryPage);

    /**
     * 删除文件
     */
    void delete(Long id);
}
