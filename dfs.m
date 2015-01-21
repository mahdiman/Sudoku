function [I] = dfs(I, x, y)

	if( x < 1 || x > size(I,1) || y < 1 || y > size(I, 2) || I(x, y) == 0)
		return;
	end
	
	I(x, y) = 0;

	I = dfs(I, x+1, y);
	I = dfs(I, x+1, y);
	I = dfs(I, x, y+1);
	I = dfs(I, x, y-1);

end