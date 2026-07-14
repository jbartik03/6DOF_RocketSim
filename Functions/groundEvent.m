function [value,isterminal,direction] = groundEvent(~,x)
value = x(1)-1;    % velocity
isterminal = 1;    % stop integration
direction = -1;    % detect crossing from up to down
end