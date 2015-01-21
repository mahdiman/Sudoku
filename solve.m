function X = solve( X )

    [C,s,e] = candidates(X);

    while ~isempty(s) && isempty(e)
        X(s) = C{s};
        [C,s,e] = candidates(X);
    end

    if ~isempty(e)
        return
    end

    if any(X(:) == 0)
        Y = X;
        Z = find(X(:) == 0,1);      % The first unfilled cell.
        exp = [C{Z}];
        for r = 1 : numel(exp)      % Iterate over candidates.
            X = Y;
            X(Z) = exp(r);          % Insert a tentative value.
            X = solve(X);           % Recursive call.
            if all(X(:) > 0)        % Found a solution.
                return
            end
        end
    end

    function [C,s,e] = candidates(X)
        C = cell(9,9);
        tri = @(k) 3*ceil(k/3-1) + (1:3);
        for j = 1:9
            for i = 1:9
                if X(i,j)==0
                    z = 1:9;
                    z(nonzeros(X(i,:))) = 0;
                    z(nonzeros(X(:,j))) = 0;
                    z(nonzeros(X(tri(i),tri(j)))) = 0;
                    C{i,j} = nonzeros(z);
                end
            end
        end
        L = cellfun(@length,C);   % Number of candidates.
        s = find(X==0 & L==1,1);
        e = find(X==0 & L==0,1);
    end % candidates

end % solve