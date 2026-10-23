// Ad Maiorem Dei Gloriam!
shader_type canvas_item;

uniform float spacing = 25.0;
uniform float animation_progress : hint_range(0.0, 1.0) = 0.0;
uniform float dot_size : hint_range(0.0, 1.0) = 1.0;
uniform vec4 dot_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

void fragment() {
    if (animation_progress <= 0.0) {
        discard; // 关键修正：只保留 discard
    }
	
    vec2 screen_size = vec2(1.0) / SCREEN_PIXEL_SIZE * 2.0;
    vec2 grid_count = floor(screen_size / spacing); 
	
    vec2 norm_pos = UV * screen_size / (grid_count * spacing);
	
    float delay = (norm_pos.x + norm_pos.y) * 0.5;
	
    float visible_threshold = delay * 0.1 + 0.01; // 随延迟增加的阈值
    if (animation_progress < visible_threshold) {
        discard;
    } 
	
    float transition = 0.3;
    float scale = smoothstep(
        delay - transition,
        delay + transition,
        animation_progress * (1.0 + transition)
    ); 
	
    // 机制2：基于尺寸的过滤
    if (scale < 0.005) { // 完全消除微小残留
        discard;
    }
    
    vec2 grid_center = (floor(UV * screen_size / spacing) + 0.5) * spacing;
    float dist = length(UV * screen_size - grid_center);
    float dot_radius = dot_size * scale * spacing * 0.8;
    
    float alpha = 1.0 - smoothstep(
        max(dot_radius - 1.5, 0.0),
        dot_radius + 1.5, 
        dist
    );
    
    if (alpha < 0.01) discard; 
    
    COLOR = vec4(dot_color.rgb, alpha);
}