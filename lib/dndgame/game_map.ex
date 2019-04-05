defmodule Dndgame.GameMap do

  def get_map() do
 [%{"x" => 39, "y" => 12}, %{"x" => 40, "y" => 12}, %{"x" => 41, "y" => 12}, %{"x" => 42, "y" => 12}, %{"x" => 43, "y" => 12}, %{"x" => 42, "y" => 14},
%{"x" => 42, "y" => 15}, %{"x" => 42, "y" => 16}, %{"x" => 43, "y" => 17}, %{"x" => 44, "y" => 17}, %{"x" => 45, "y" => 17}, %{"x" => 46, "y" => 17},
%{"x" => 47, "y" => 18}, %{"x" => 47, "y" => 19}, %{"x" => 47, "y" => 20}, %{"x" => 46, "y" => 21}, %{"x" => 47, "y" => 22}, %{"x" => 48, "y" => 23}, 
%{"x" => 48, "y" => 24}, %{"x" => 49, "y" => 24}, %{"x" => 50, "y" => 23}, %{"x" => 51, "y" => 22}, %{"x" => 52, "y" => 22}, %{"x" => 53, "y" => 22}, 
%{"x" => 54, "y" => 21}, %{"x" => 55, "y" => 20}, 
%{"x" => 56, "y" => 21}, %{"x" => 56, "y" => 22}, %{"x" => 56, "y" => 23}, %{"x" => 57, "y" => 23}, %{"x" => 58, "y" => 23}, %{"x" => 59, "y" => 24}, %{"x" => 58, "y" => 25}, %{"x" => 57, "y" => 26}, %{"x" => 56, "y" => 26}, %{"x" => 55, "y" => 26}, %{"x" => 54, "y" => 26}, %{"x" => 54, "y" => 27}, %{"x" => 54, "y" => 28}, 
%{"x" => 43, "y" => 13}, %{"x" => 55, "y" => 28}, %{"x" => 56, "y" => 28}, %{"x" => 57, "y" => 29}, %{"x" => 56, "y" => 30}, %{"x" => 57, "y" => 31}, %{"x" => 56, "y" => 32}, %{"x" => 56, "y" => 33}, %{"x" => 55, "y" => 34}, %{"x" => 55, "y" => 35}, %{"x" => 53, "y" => 36}, %{"x" => 52, "y" => 36}, %{"x" => 52, "y" => 37}, 
%{"x" => 52, "y" => 38}, %{"x" => 51, "y" => 38}, %{"x" => 50, "y" => 38}, %{"x" => 53, "y" => 38}, %{"x" => 54, "y" => 38}, %{"x" => 55, "y" => 37}, %{"x" => 56, "y" => 37}, %{"x" => 57, "y" => 38}, %{"x" => 58, "y" => 38}, %{"x" => 58, "y" => 39}, %{"x" => 59, "y" => 40}, %{"x" => 59, "y" => 41}, %{"x" => 59, "y" => 42}, 
%{"x" => 60, "y" => 43}, %{"x" => 61, "y" => 43}, %{"x" => 62, "y" => 43}, %{"x" => 63, "y" => 43}, %{"x" => 64, "y" => 44}, %{"x" => 64, "y" => 45}, %{"x" => 64, "y" => 46}, %{"x" => 63, "y" => 47}, %{"x" => 63, "y" => 48}, %{"x" => 64, "y" => 48}, %{"x" => 65, "y" => 49}, %{"x" => 65, "y" => 50}, %{"x" => 64, "y" => 51}, 
%{"x" => 63, "y" => 51}, %{"x" => 65, "y" => 52}, %{"x" => 64, "y" => 53}, %{"x" => 64, "y" => 54}, %{"x" => 63, "y" => 55}, %{"x" => 63, "y" => 56}, %{"x" => 63, "y" => 57}, %{"x" => 62, "y" => 58}, %{"x" => 61, "y" => 59}, %{"x" => 60, "y" => 60}, %{"x" => 60, "y" => 61}, %{"x" => 59, "y" => 61}, %{"x" => 58, "y" => 61}, 
%{"x" => 58, "y" => 62}, %{"x" => 59, "y" => 63}, %{"x" => 60, "y" => 63}, %{"x" => 61, "y" => 63}, %{"x" => 62, "y" => 63}, %{"x" => 63, "y" => 63}, %{"x" => 64, "y" => 64}, %{"x" => 65, "y" => 65}, %{"x" => 64, "y" => 66}, %{"x" => 64, "y" => 67}, %{"x" => 63, "y" => 68}, %{"x" => 62, "y" => 67}, %{"x" => 61, "y" => 66}, 
%{"x" => 60, "y" => 66}, %{"x" => 60, "y" => 65}, %{"x" => 59, "y" => 65}, %{"x" => 58, "y" => 66}, %{"x" => 58, "y" => 67}, %{"x" => 57, "y" => 68}, %{"x" => 58, "y" => 68}, %{"x" => 56, "y" => 68}, %{"x" => 55, "y" => 69}, %{"x" => 54, "y" => 69}, %{"x" => 53, "y" => 68}, %{"x" => 52, "y" => 67}, %{"x" => 51, "y" => 68}, 
%{"x" => 50, "y" => 68}, %{"x" => 50, "y" => 67}, %{"x" => 49, "y" => 66}, %{"x" => 49, "y" => 65}, %{"x" => 50, "y" => 64}, %{"x" => 50, "y" => 63}, %{"x" => 49, "y" => 63}, %{"x" => 48, "y" => 63}, %{"x" => 47, "y" => 63}, %{"x" => 46, "y" => 63}, %{"x" => 46, "y" => 64}, %{"x" => 45, "y" => 65}, %{"x" => 45, "y" => 66}, 
%{"x" => 44, "y" => 67}, %{"x" => 43, "y" => 67}, %{"x" => 42, "y" => 66}, %{"x" => 41, "y" => 65}, %{"x" => 41, "y" => 64}, %{"x" => 40, "y" => 63}, %{"x" => 39, "y" => 62}, %{"x" => 38, "y" => 62}, %{"x" => 37, "y" => 62}, %{"x" => 36, "y" => 62}, %{"x" => 36, "y" => 63}, %{"x" => 35, "y" => 64}, %{"x" => 35, "y" => 65}, 
%{"x" => 35, "y" => 66}, %{"x" => 35, "y" => 66}, %{"x" => 34, "y" => 67}, %{"x" => 34, "y" => 68}, %{"x" => 33, "y" => 69}, %{"x" => 32, "y" => 69}, %{"x" => 31, "y" => 69}, %{"x" => 30, "y" => 68}, %{"x" => 30, "y" => 67}, %{"x" => 30, "y" => 66}, %{"x" => 30, "y" => 65}, %{"x" => 30, "y" => 64}, %{"x" => 30, "y" => 63}, 
%{"x" => 29, "y" => 63}, %{"x" => 29, "y" => 64}, %{"x" => 29, "y" => 65}, %{"x" => 29, "y" => 66}, %{"x" => 28, "y" => 66}, %{"x" => 27, "y" => 67}, %{"x" => 26, "y" => 67}, %{"x" => 25, "y" => 67}, %{"x" => 24, "y" => 67}, %{"x" => 24, "y" => 68}, %{"x" => 23, "y" => 69}, %{"x" => 22, "y" => 69}, %{"x" => 21, "y" => 69}, 
%{"x" => 21, "y" => 68}, %{"x" => 21, "y" => 67}, %{"x" => 21, "y" => 66}, %{"x" => 21, "y" => 65}, %{"x" => 20, "y" => 64}, %{"x" => 20, "y" => 63}, %{"x" => 19, "y" => 62}, %{"x" => 18, "y" => 63}, %{"x" => 17, "y" => 62}, %{"x" => 16, "y" => 61}, %{"x" => 16, "y" => 60}, %{"x" => 17, "y" => 59}, %{"x" => 18, "y" => 59}, 
%{"x" => 19, "y" => 58}, %{"x" => 19, "y" => 57}, %{"x" => 20, "y" => 56}, %{"x" => 20, "y" => 55}, %{"x" => 19, "y" => 54}, %{"x" => 20, "y" => 53}, %{"x" => 21, "y" => 53}, %{"x" => 31, "y" => 52}, %{"x" => 21, "y" => 51}, %{"x" => 20, "y" => 50}, %{"x" => 20, "y" => 49}, %{"x" => 19, "y" => 48}, %{"x" => 18, "y" => 48}, 
%{"x" => 17, "y" => 48}, %{"x" => 16, "y" => 47}, %{"x" => 15, "y" => 46}, %{"x" => 15, "y" => 45}, %{"x" => 16, "y" => 44}, %{"x" => 17, "y" => 44}, %{"x" => 18, "y" => 43}, %{"x" => 18, "y" => 42}, %{"x" => 18, "y" => 41}, %{"x" => 18, "y" => 40}, %{"x" => 17, "y" => 39}, %{"x" => 16, "y" => 39}, %{"x" => 15, "y" => 38}, 
%{"x" => 15, "y" => 37}, %{"x" => 16, "y" => 37}, %{"x" => 17, "y" => 36}, %{"x" => 18, "y" => 37}, %{"x" => 19, "y" => 37}, %{"x" => 20, "y" => 38}, %{"x" => 21, "y" => 39}, %{"x" => 21, "y" => 40}, %{"x" => 22, "y" => 41}, %{"x" => 23, "y" => 41}, %{"x" => 23, "y" => 40}, %{"x" => 23, "y" => 39}, %{"x" => 22, "y" => 38}, 
%{"x" => 22, "y" => 37}, %{"x" => 21, "y" => 36}, %{"x" => 20, "y" => 35}, %{"x" => 20, "y" => 34}, %{"x" => 21, "y" => 34}, %{"x" => 22, "y" => 34}, %{"x" => 22, "y" => 33}, %{"x" => 21, "y" => 32}, %{"x" => 20, "y" => 31}, %{"x" => 20, "y" => 30}, %{"x" => 19, "y" => 29}, %{"x" => 19, "y" => 28}, %{"x" => 19, "y" => 27}, 
%{"x" => 20, "y" => 26}, %{"x" => 21, "y" => 25}, %{"x" => 22, "y" => 24}, %{"x" => 23, "y" => 24}, %{"x" => 24, "y" => 25}, %{"x" => 24, "y" => 26}, %{"x" => 25, "y" => 27}, %{"x" => 26, "y" => 27}, %{"x" => 27, "y" => 28}, %{"x" => 28, "y" => 27}, %{"x" => 29, "y" => 27}, %{"x" => 30, "y" => 28}, %{"x" => 31, "y" => 28}, 
%{"x" => 31, "y" => 27}, %{"x" => 31, "y" => 26}, %{"x" => 31, "y" => 25}, %{"x" => 31, "y" => 24}, %{"x" => 31, "y" => 23}, %{"x" => 31, "y" => 22}, %{"x" => 32, "y" => 21}, %{"x" => 33, "y" => 20}, %{"x" => 34, "y" => 20}, %{"x" => 30, "y" => 21}, %{"x" => 30, "y" => 20}, %{"x" => 30, "y" => 19}, %{"x" => 31, "y" => 18}, 
%{"x" => 32, "y" => 17}, %{"x" => 33, "y" => 16}, %{"x" => 34, "y" => 15}, %{"x" => 35, "y" => 14}, %{"x" => 36, "y" => 14}, %{"x" => 37, "y" => 14}, %{"x" => 37, "y" => 15}, %{"x" => 37, "y" => 16}, %{"x" => 37, "y" => 17}, %{"x" => 37, "y" => 18}, %{"x" => 38, "y" => 17}, %{"x" => 38, "y" => 16}, %{"x" => 38, "y" => 12}, 
%{"x" => 37, "y" => 13}, %{"x" => 49, "y" => 38}, %{"x" => 49, "y" => 39}, %{"x" => 49, "y" => 40}, %{"x" => 49, "y" => 41}, %{"x" => 49, "y" => 42}, %{"x" => 48, "y" => 43}, %{"x" => 48, "y" => 47}, %{"x" => 48, "y" => 48}, %{"x" => 47, "y" => 48}, %{"x" => 46, "y" => 48}, %{"x" => 43, "y" => 48}, %{"x" => 42, "y" => 48}, 
%{"x" => 41, "y" => 49}, %{"x" => 39, "y" => 49}, %{"x" => 38, "y" => 49}, %{"x" => 37, "y" => 49}, %{"x" => 36, "y" => 49}, %{"x" => 35, "y" => 49}, %{"x" => 35, "y" => 50}, %{"x" => 36, "y" => 50}, %{"x" => 37, "y" => 50}, %{"x" => 36, "y" => 51}, %{"x" => 34, "y" => 49}, %{"x" => 34, "y" => 48}, %{"x" => 35, "y" => 48}, 
%{"x" => 36, "y" => 48}, %{"x" => 37, "y" => 48}, %{"x" => 38, "y" => 48}, %{"x" => 34, "y" => 50}, %{"x" => 38, "y" => 50}, %{"x" => 37, "y" => 51}, %{"x" => 35, "y" => 51}]   
  end
end
