package odd.client.common.point.controller;

import odd.client.common.point.service.PointService;
import odd.client.global.security.CustomUserDetails;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/point")
public class PointController {

    private final PointService pointService;

    @Autowired
    public PointController(PointService pointService) {
        this.pointService = pointService;
    }

    @PreAuthorize("isAuthenticated()")
    @GetMapping
    public Long getTotalPoints(@AuthenticationPrincipal CustomUserDetails userDetails) {
        if (userDetails == null || userDetails.getUser() == null) {
            throw new IllegalArgumentException("인증된 사용자 정보를 찾을 수 없습니다.");
        }
        Long userId = userDetails.getUser().getId();
        return pointService.getTotalPoints(userId);
    }
}
