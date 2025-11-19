shader_type canvas_item;

uniform sampler2D front_tex : source_color, filter_nearest;
uniform sampler2D back_tex  : source_color, filter_nearest;

uniform float flip : hint_range(0.0, 1.0) = 0.0;
// 0.0 = front fully visible
// 0.5 = edge-on (invisible)
// 1.0 = backside fully visible

void fragment() {
    vec2 uv = UV;

  
    float angle = flip * 3.14159265;


    float squish = abs(cos(angle));

   
    if (squish < 0.02) {
        COLOR = vec4(0.0);
    } 
    else 
    {
      
        float centered = uv.x - 0.5;
        centered /= squish;
        uv.x = centered + 0.5;

        bool showing_back = flip > 0.5;

      
        if (showing_back) {
            uv.x = 1.0 - uv.x;
        }

       
        if (uv.x < 0.0 || uv.x > 1.0) {
            COLOR = vec4(0.0);
        } 
        else 
        {
            vec4 front_col = texture(front_tex, uv);
            vec4 back_col  = texture(back_tex,  uv);

            
            COLOR = showing_back ? back_col : front_col;
        }
    }
}