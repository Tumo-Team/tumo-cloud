package cn.tycoding.cloud.common.redis.utils;

import lombok.Data;
import lombok.experimental.Accessors;

import java.io.Serializable;
import java.util.Date;
import java.util.Set;

/**
 * 对Redis中Token信息的扩展封装
 *
 * @author tycoding
 * @since 2021/6/12
 */
@Data
@Accessors(chain = true)
public class TokenInfo implements Serializable {
    private static final long serialVersionUID = -1331900349298552602L;

    /**
     * Token 值
     */
    private String value;

    /**
     * 过期时间
     */
    private Date expiration;

    /**
     * Token类型
     */
    private String tokenType;

    /**
     * 刷新Token
     */
    private String refreshToken;

    /**
     * Scope
     */
    private Set<String> scope;

    /**
     * 用户名
     */
    private String username;
}
