package cn.tycoding.cloud.upms.biz.service;

import cn.tycoding.cloud.upms.api.entity.SysDictItem;
import com.baomidou.mybatisplus.extension.service.IService;

/**
 * 字典项表(SysDictItem)表服务接口
 *
 * @author TyCoding
 * @since 2021-08-06
 */
public interface SysDictItemService extends IService<SysDictItem> {

    /**
     * 新增字典项
     *
     * @param sysDictItem 字典项信息
     */
    void addDictItem(SysDictItem sysDictItem);
}

