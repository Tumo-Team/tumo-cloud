package cn.tycoding.cloud.upms.biz.service.impl;

import cn.tycoding.cloud.upms.api.entity.SysDict;
import cn.tycoding.cloud.upms.api.entity.SysDictItem;
import cn.tycoding.cloud.upms.biz.mapper.SysDictItemMapper;
import cn.tycoding.cloud.upms.biz.mapper.SysDictMapper;
import cn.tycoding.cloud.upms.biz.service.SysDictItemService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

/**
 * 字典项表(SysDictItem)表服务实现类
 *
 * @author TyCoding
 * @since 2021-08-06
 */
@Service
@RequiredArgsConstructor
public class SysDictItemServiceImpl extends ServiceImpl<SysDictItemMapper, SysDictItem> implements SysDictItemService {

    private final SysDictMapper sysDictMapper;
    private final SysDictItemMapper sysDictItemMapper;

    @Override
    public void addDictItem(SysDictItem sysDictItem) {
        SysDict sysDict = sysDictMapper.selectById(sysDictItem.getDictId());
        if (sysDict != null) {
            sysDictItem.setDictId(sysDict.getId());
            sysDictItem.setIsSystem(sysDict.getIsSystem());

            sysDictItemMapper.insert(sysDictItem);
        }
    }
}

