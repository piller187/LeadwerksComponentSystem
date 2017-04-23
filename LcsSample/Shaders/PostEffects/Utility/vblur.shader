SHADER version 1
@OpenGL2.Vertex
#version 400

uniform mat4 projectionmatrix;
uniform mat4 drawmatrix;
uniform vec2 offset;
uniform vec2 position[4];

in vec3 vertex_position;

void main(void)
{
	gl_Position = projectionmatrix * (drawmatrix * vec4(position[gl_VertexID]+offset, 0.0, 1.0));
}
@OpenGLES2.Vertex

@OpenGLES2.Fragment

@OpenGL4.Vertex
#version 400

uniform mat4 projectionmatrix;
uniform mat4 drawmatrix;
uniform vec2 offset;
uniform vec2 position[4];

in vec3 vertex_position;

void main(void)
{
	gl_Position = projectionmatrix * (drawmatrix * vec4(position[gl_VertexID]+offset, 0.0, 1.0));
}
@OpenGL4.Fragment
#version 400

uniform sampler2D texture0;
uniform bool isbackbuffer;
uniform vec2 buffersize;

out vec4 fragData0;

void main(void)
{
	vec2 texcoord = vec2(gl_FragCoord.xy/buffersize);
	if (isbackbuffer) texcoord.y = 1.0 - texcoord.y;
	
	const float offset[3] = float[]( 0.0, 1.3846153846, 3.2307692308 );
	const float weight[3] = float[]( 0.2270270270, 0.3162162162, 0.0702702703 );
	
	fragData0 = texture( texture0,texcoord) * weight[0];
	for (int i=1; i<3; i++)
	{
		fragData0 += texture( texture0, texcoord+vec2(0.0, offset[i]/textureSize(texture0,0).y) ) * weight[i];
		fragData0 += texture( texture0, texcoord-vec2(0.0, offset[i]/textureSize(texture0,0).y) ) * weight[i];
	}
}
