package cn.tycoding.cloud.upms.biz.mapper;

import cn.tycoding.cloud.upms.api.entity.OssFile;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;

/**
 * 资源文件表（OssFile）数据访问层
 *
 * @author tycoding
 * @since 2021/5/20
 */
@Mapper
public interface OssFileMapper extends BaseMapper<OssFile> {
}
