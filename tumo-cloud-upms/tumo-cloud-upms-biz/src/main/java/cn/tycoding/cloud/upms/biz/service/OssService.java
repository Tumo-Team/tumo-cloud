package cn.tycoding.cloud.upms.biz.service;

import cn.tycoding.cloud.upms.api.entity.OssFile;
import org.springframework.web.multipart.MultipartFile;

/**
 * @author tycoding
 * @since 2021/5/25
 */
public interface OssService {

    OssFile put(MultipartFile file);

}
