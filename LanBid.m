function [U, V, B, beta1] = LanBid(A, b, k, reorth)
    % Lanczos bidiagonalization implemented in double precision

    % Haibo Li, 2022.6.29

    % The first step Golub-Kanhan Bidiagonalization
    beta1 = norm(b);
    u = b / beta1; U(:, 1) = u;
    r = A' * u;
    alpha = norm(r); B(1, 1) = alpha;
    v = r / alpha; V(:, 1) = v;

    % The k-th step Golub-Kahan Bidiagonalization
    for i = 1:k
        fprintf('Lanczos bidiagonalizaton: iteration %d\n', k);
        p = A * v - alpha * u;
        u = p;
        if (reorth == 0)
            u = u;
        elseif (reorth == 1)
            u = u - U(:, 1:i) * U(:, 1:i)' * u;
        elseif (reorth == 2)
            for j = 1:i % MGS
                eta = u' * U(:, j);
                u = u - eta * U(:, j);
            end
        end

        beta = norm(u); B(i + 1, i) = beta;
        u = u / beta; U(:, i + 1) = u;
        r = A' * u - beta * v;
        v = r;
        if (reorth == 0)
            v = v;
        elseif (reorth == 1)
            v = v - V(:, 1:i) * V(:, 1:i)' * v;
        elseif (reorth == 2)
            for j = 1:i % MGS
                xi = v' * V(:, j);
                v = v - xi * V(:, j);
            end
        end

        alpha = norm(v); B(i + 1, i + 1) = alpha;
        v = v / alpha; V(:, i + 1) = v;
    end
