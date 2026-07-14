% =========================================================================
% 6DOF Rocket Flight Dynamics Simulator
%
% Author: Jonathan A. Bartik
% Created: April 2026
%
% Copyright (c) 2026 Jonathan A. Bartik
% All Rights Reserved
% =========================================================================

function plot6DOFresults(results, i, timespan)
%{
    This is the plotting function. When called, it produces the plots from
    the massive databank 'results' produced by ROCKET_SIMULATOR_6DOF.m.
%}

colors = {
    [0.0000, 0.4470, 0.7410]  % blue
    [0.8500, 0.3250, 0.0980]  % orange
    [0.4660, 0.6740, 0.1880]  % green
    [0.4940, 0.1840, 0.5560]  % purple
    [0.9290, 0.6940, 0.1250]  % yellow
    [0.3010, 0.7450, 0.9330]  % cyan
    [0.6350, 0.0780, 0.1840]  % dark red
    [0.2500, 0.2500, 0.2500]  % dark gray
    [0.7500, 0.2500, 0.2500]  % maroon
    [0.2500, 0.7500, 0.2500]  % bright green
    [0.2500, 0.2500, 0.7500]  % strong blue
    [0.7500, 0.7500, 0.2500]  % olive
    [0.7500, 0.2500, 0.7500]  % magenta
};

legendEntries = strings(1, i);

%% Displacements
% Altitude
figure;
hold on;
for k = 1:i
    angle = results(k).angle;
    altitude = results(k).altitude;
    time = results(k).time;

    [maxAlt, idx] = max(altitude);
    apogee_km = maxAlt / 1000;
    plot(time, altitude/1000, ...
        'Color', colors{mod(k-1,13) + 1}, 'LineWidth', 5);
    plot(time(idx), altitude(idx)/1000, ...
        'o', ...
        'MarkerSize', 15, ...
        'MarkerFaceColor', colors{mod(k-1,13) + 1}, ...
        'MarkerEdgeColor', 'k', ...
        'HandleVisibility', 'off');
    if mod(angle,1) == 0
        legendEntries(k) = sprintf('%d°: %.2fkm at %.2fs', ...
                               angle, apogee_km, time(idx));
    else
        legendEntries(k) = sprintf('%.1f°: %.2fkm at %.2fs', ...
                               angle, apogee_km, time(idx));
    end
end
hold off;
set(gcf,'color',[1 1 1]);
set(gca,'color',[0.95 0.95 0.95],'FontSize',25);
xlabel("Time (s)","FontSize",20)
xlim(timespan)
ylabel("Altitude (km)","FontSize",20)
legend(legendEntries, 'FontSize', 10, 'Location', 'best')
grid on

% Distance 
figure
hold on;
for k = 1:i
    angle = results(k).angle;
    distance = results(k).distance;
    time = results(k).time;
    [maxDist, idxDist] = max(distance);
    range_km = maxDist / 1000;
    plot(time, distance/1000, 'Color', colors{mod(k-1,13) + 1}, 'LineWidth', 5)
    plot(time(idxDist), distance(idxDist)/1000, ...
        'o', ...
        'MarkerSize', 15, ...
        'MarkerFaceColor', colors{mod(k-1,13) + 1}, ...
        'MarkerEdgeColor', 'k', ...
        'HandleVisibility', 'off');
    if mod(angle,1) == 0
        legendEntries(k) = sprintf('%d°: %.2fkm, %.1fs', ...
                               angle, range_km, time(idxDist));
    else
        legendEntries(k) = sprintf('%.1f°: %.2fkm, %.1fs', ...
                               angle, range_km, time(idxDist));
    end
end
hold off;
set(gcf,'color',[1 1 1]);
set(gca,'color',[0.95 0.95 0.95],'FontSize',25);
xlabel("Time (s)","FontSize",20)
xlim(timespan)
ylabel("Distance (km)","FontSize",20)
legend(legendEntries, 'FontSize', 10, 'Location', 'best')
grid on

% Sidewalk 
figure
hold on;
for k = 1:i
    angle = results(k).angle;
    sidewalk = results(k).sidewalk;
    time = results(k).time;
    [maxDist, idxDist] = max(sidewalk);
    range_km = maxDist / 1000;
    plot(time, sidewalk/1000, 'Color', colors{mod(k-1,13) + 1}, 'LineWidth', 5)
    plot(time(idxDist), sidewalk(idxDist)/1000, ...
        'o', ...
        'MarkerSize', 15, ...
        'MarkerFaceColor', colors{mod(k-1,13) + 1}, ...
        'MarkerEdgeColor', 'k', ...
        'HandleVisibility', 'off');
    if mod(angle,1) == 0
        legendEntries(k) = sprintf('%d°: %.2fkm', ...
                               angle, range_km);
    else
        legendEntries(k) = sprintf('%.1f°: %.2fkm', ...
                               angle, range_km);
    end
end
hold off;
set(gcf,'color',[1 1 1]);
set(gca,'color',[0.95 0.95 0.95],'FontSize',25);
xlabel("Time (s)","FontSize",20)
xlim(timespan)
ylabel("Sidewalk (km)","FontSize",20)
legend(legendEntries, 'FontSize', 10, 'Location', 'best')
grid on

% Altitude vs Distance with flight angles
figure
hold on;
dist_lim = 0;
for k = 1:i
    [maxAlt, idx] = max(results(k).altitude);
    apogee = (maxAlt / 1000);
    maxDist = max(results(k).distance);
    range = (maxDist / 1000);
    if range > dist_lim
        dist_lim = range;
    end
    plot(results(k).distance/1000, results(k).altitude/1000, ...
        'Color', colors{mod(k-1,13) + 1}, 'LineWidth', 5);
    plot(results(k).distance(idx)/1000, results(k).altitude(idx)/1000, ...
        'o', ...
        'MarkerSize', 15, ...
        'MarkerFaceColor', colors{mod(k-1,13) + 1}, ...
        'MarkerEdgeColor', 'k', ...
        'HandleVisibility', 'off');
    if mod(results(k).angle,1) == 0
        legendEntries(k) = sprintf('%d°: %.2fkm ↑ | %.2fkm →', ...
                               results(k).angle, apogee, range);
    else
        legendEntries(k) = sprintf('%.1f°: %.2fkm ↑ | %.2fkm →', ...
                               results(k).angle, apogee, range);
    end
end
hold off;
set(gcf,'color',[1 1 1]);
set(gca,'color',[0.95 0.95 0.95],'FontSize', 25);
xlabel("Distance (km)",'FontSize', 20)
ylabel("Altitude (km)",'FontSize', 20)
xlim([0 dist_lim*1.05])
legend(legendEntries, 'FontSize', 10, 'Location', 'best')
grid on

% Trajectory
figure; 
hold on;
for k = 1:i
    [maxAlt,l] = max(results(k).altitude);
    apogee = (maxAlt / 1000);
    [maxDist,j] = max(results(k).distance);
    range = (maxDist / 1000);
    maxWalk = max(abs(results(k).sidewalk)) / 1000;
    plot3(results(k).distance./1000, abs(results(k).sidewalk./1000),...
        results(k).altitude./1000,'Color',colors{mod(k-1,13) + 1},'LineWidth',5)
    plot3(results(k).distance(l)./1000, abs(results(k).sidewalk(l)./1000),maxAlt./1000, ...
            'o', ...
            'MarkerSize', 15, ...
            'MarkerFaceColor', colors{mod(k-1,13) + 1}, ...
            'MarkerEdgeColor', colors{mod(k-1,13) + 1}, ...
            'HandleVisibility', 'off');
    plot3(maxDist./1000, abs(results(k).sidewalk(j)./1000),results(k).altitude(j)./1000, ...
            's', ...
            'MarkerSize', 15, ...
            'MarkerFaceColor', colors{mod(k-1,13) + 1}, ...
            'MarkerEdgeColor', colors{mod(k-1,13) + 1}, ...
            'HandleVisibility', 'off');
    if mod(results(k).angle,1) == 0
        legendEntries(k) = sprintf('%d°: %.2fkm Apogee | %.2fkm Dist. | %.2fkm Walk', ...
                               results(k).angle, apogee, range, maxWalk);
    else
        legendEntries(k) = sprintf('%.1f°: %.2fkm Apogee | %.2fkm Dist. | %.2fkm Walk', ...
                               results(k).angle, apogee, range, maxWalk);
    end
end
hold off;
set(gcf,'color',[1 1 1]);
set(gca,'color',[0.95 0.95 0.95],'FontSize', 25);
xlabel('Distance (km)',"FontSize",20)
ylabel('Sidewalk (km)',"FontSize",20)
zlabel('Altitude (km)',"FontSize",20)
legend(legendEntries, 'FontSize', 10, 'Location', 'best')
grid on
view(30,25)

%% Velocities
% Vertical Velocity
figure; 
hold on;
for k = 1:i
    angle = results(k).angle;
    velocity_v = results(k).v_x;
    time = results(k).time;
    [~, idxApogee] = max(results(k).altitude);
    [maxAscentVel, iAscent] = max(velocity_v(1:idxApogee));
    tAscent = time(iAscent);
    [maxDescentVel, iDescRel] = min(velocity_v(idxApogee:end));
    iDescent = iDescRel + idxApogee - 1;
    tDescent = time(iDescent);
    plot(time, velocity_v, 'Color', colors{mod(k-1,13) + 1}, 'LineWidth', 5)
    plot(tAscent, maxAscentVel, 'o', 'MarkerSize', 15, 'MarkerFaceColor'...
        , colors{mod(k-1,13) + 1}, 'MarkerEdgeColor', 'k', 'HandleVisibility', 'off');
    plot(tDescent, maxDescentVel, 's', 'MarkerSize', 15, ...
        'MarkerFaceColor', colors{mod(k-1,13) + 1}, 'MarkerEdgeColor', 'k', ...
        'HandleVisibility', 'off');
    if mod(angle,1) == 0
        legendEntries(k) = sprintf('%d°: ↑ %.1f m/s | ↓ %.1f m/s', ...
                               angle, maxAscentVel, maxDescentVel);
    else
        legendEntries(k) = sprintf('%.1f°: ↑ %.1f m/s | ↓ %.1f m/s', ...
                               angle, maxAscentVel, maxDescentVel);
    end
end
hold off;
xlabel("Time (s)","FontSize",20)
ylabel("Vert. Vel. (m/s)","FontSize",20)
set(gcf,'color',[1 1 1]);
set(gca,'color',[0.95 0.95 0.95],'FontSize',25);
legend(legendEntries, 'Location', 'best', 'FontSize', 10)
grid on

% Horizontal Velocity
figure
hold on;
for k = 1:i
    angle = results(k).angle;
    velocity_h = results(k).v_y;
    time = results(k).time;
    [~, idxApogee] = max(results(k).altitude);
    [maxAscentVel, iAscent] = max(velocity_h(1:idxApogee));
    tAscent = time(iAscent);
    [maxDescentVel, iDescRel] = min(velocity_h(idxApogee:end));
    iDescent = iDescRel + idxApogee - 1;
    tDescent = time(iDescent);
    plot(time, velocity_h, 'Color', colors{mod(k-1,13) + 1}, 'LineWidth', 5)
    plot(tAscent, maxAscentVel, 'o', 'MarkerSize', 15, 'MarkerFaceColor'...
        , colors{mod(k-1,13) + 1}, 'MarkerEdgeColor', 'k', 'HandleVisibility', 'off');
    plot(tDescent, maxDescentVel, 's', 'MarkerSize', 15, ...
        'MarkerFaceColor', colors{mod(k-1,13) + 1}, 'MarkerEdgeColor', 'k', ...
        'HandleVisibility', 'off');
    if mod(angle,1) == 0
        legendEntries(k) = sprintf('%d°: ↑ %.1f m/s | ↓ %.1f m/s', ...
                               angle, maxAscentVel, maxDescentVel);
    else
        legendEntries(k) = sprintf('%.1f°: ↑ %.1f m/s | ↓ %.1f m/s', ...
                               angle, maxAscentVel, maxDescentVel);
    end
end
hold off;
xlabel("Time (s)","FontSize",20)
ylabel("Horiz. Vel. (m/s)","FontSize",20)
set(gcf,'color',[1 1 1]);
set(gca,'color',[0.95 0.95 0.95],'FontSize',25);
legend(legendEntries, 'Location', 'best', 'FontSize', 10)
grid on

% Lateral Velocity
figure
hold on;
for k = 1:i
    angle = results(k).angle;
    velocity_l = results(k).v_z;
    time = results(k).time;
    [~, idxApogee] = max(results(k).altitude);
    [maxAscentVel, iAscent] = max(velocity_l(1:idxApogee));
    tAscent = time(iAscent);
    [maxDescentVel, iDescRel] = min(velocity_l(idxApogee:end));
    iDescent = iDescRel + idxApogee - 1;
    tDescent = time(iDescent);
    plot(time, velocity_l, 'Color', colors{mod(k-1,13) + 1}, 'LineWidth', 5)
    plot(tAscent, maxAscentVel, 'o', 'MarkerSize', 15, 'MarkerFaceColor'...
        , colors{mod(k-1,13) + 1}, 'MarkerEdgeColor', 'k', 'HandleVisibility', 'off');
    plot(tDescent, maxDescentVel, 's', 'MarkerSize', 15, ...
        'MarkerFaceColor', colors{mod(k-1,13) + 1}, 'MarkerEdgeColor', 'k', ...
        'HandleVisibility', 'off');
    if mod(angle,1) == 0
        legendEntries(k) = sprintf('%d°: ↑ %.1f m/s | ↓ %.1f m/s', ...
                               angle, maxAscentVel, maxDescentVel);
    else
        legendEntries(k) = sprintf('%.1f°: ↑ %.1f m/s | ↓ %.1f m/s', ...
                               angle, maxAscentVel, maxDescentVel);
    end
end
hold off;
xlabel("Time (s)","FontSize",20)
ylabel("Lat. Vel. (m/s)","FontSize",20)
set(gcf,'color',[1 1 1]);
set(gca,'color',[0.95 0.95 0.95],'FontSize',25);
legend(legendEntries, 'Location', 'best', 'FontSize', 10)
grid on

% Velocity
figure 
hold on;
for k = 1:i
    angle = results(k).angle;
    vel = results(k).velocity;
    time = results(k).time;
    plot(time, vel, 'Color', colors{mod(k-1,13) + 1}, 'LineWidth', 5)
    if mod(angle,1) == 0
        legendEntries(k) = sprintf('%d°', angle);
    else
        legendEntries(k) = sprintf('%.1f°', angle);
    end
end
hold off;
xlabel("Time (s)","FontSize",20)
ylabel("Velocity (m/s)","FontSize",20)
set(gcf,'color',[1 1 1]);
set(gca,'color',[0.95 0.95 0.95],'FontSize',25);
legend(legendEntries, 'Location', 'best', 'FontSize', 10)
grid on

% 3D Velocity
figure; 
hold on;
for k = 1:i
    v_x = results(k).v_x;
    v_y = results(k).v_y;
    v_z = results(k).v_z;
    [maxVVel,m] = max(v_x);
    maxHVel = v_y(m);
    maxLVel = v_z(m);
    maxV = sqrt(maxVVel^2 + maxHVel^2 + maxLVel^2);

    plot3(v_y, v_z, v_x, 'Color', colors{mod(k-1,13) + 1}, 'LineWidth', 5);
    plot3(v_y(1), v_z(1), v_x(1), 'o', 'MarkerSize', 15, 'MarkerFaceColor'...
        , 'g', 'MarkerEdgeColor', 'g','HandleVisibility','off');
    plot3(v_y(end), v_z(end), v_x(end), 'o', 'MarkerSize', 15, 'MarkerFaceColor'...
            , 'r', 'MarkerEdgeColor', 'r','HandleVisibility','off');
    plot3(v_y(m), v_z(m), maxVVel, 'o', 'MarkerSize', 15, 'MarkerFaceColor'...
            , 'k', 'MarkerEdgeColor', 'k','HandleVisibility','off');
    if mod(results(k).angle,1) == 0
        legendEntries(k) = sprintf('%d°: Max Velocity at %.2f m/s', ...
                               results(k).angle, round(maxV,2));
    else
        legendEntries(k) = sprintf('%.1f°: Max Velocity at %.2f m/s', ...
                               results(k).angle, round(maxV,2));
    end
end
hold off;
set(gcf,'color',[1 1 1]);
set(gca,'color',[0.95 0.95 0.95],'FontSize', 25);
xlabel('Horiz. Velocity (m/s)',"FontSize",20)
ylabel('Lat. Velocity (m/s)',"FontSize",20)
zlabel('Vert. Velocity (m/s)',"FontSize",20)
legend(legendEntries, 'FontSize', 10, 'Location', 'best')
grid on
view(30,25)

%% Attitudes
% Roll
figure
hold on;
for k = 1:i
    angle = results(k).angle;
    roll = results(k).roll;
    time = results(k).time;
    plot(time, roll, 'Color', colors{mod(k-1,13) + 1}, 'LineWidth', 5)
    if mod(angle,1) == 0
        legendEntries(k) = sprintf('%d°', angle);
    else
        legendEntries(k) = sprintf('%.1f°', angle);
    end
end
hold off;
xlabel("Time (s)","FontSize",20)
ylabel("Roll (rad)","FontSize",20)
set(gcf,'color',[1 1 1]);
set(gca,'color',[0.95 0.95 0.95],'FontSize',25);
legend(legendEntries, 'Location', 'best', 'FontSize', 10)
grid on

% Pitch
figure
hold on;
for k = 1:i
    angle = results(k).angle;
    pitch = results(k).pitch;
    time = results(k).time;
    plot(time, pitch, 'Color', colors{mod(k-1,13) + 1}, 'LineWidth', 5)
    if mod(angle,1) == 0
        legendEntries(k) = sprintf('%d°', angle);
    else
        legendEntries(k) = sprintf('%.1f°', angle);
    end
end
hold off;
xlabel("Time (s)","FontSize",20)
ylabel("Pitch (rad)","FontSize",20)
ylim([-2*pi 2*pi])
yticks([-2*pi, -pi, 0, pi, 2*pi])
yticklabels(["-2\pi", "-\pi", "0", "\pi", "2\pi"])
set(gcf,'color',[1 1 1]);
set(gca,'color',[0.95 0.95 0.95],'FontSize',25);
legend(legendEntries, 'Location', 'best', 'FontSize', 10)
grid on

% Yaw
figure
hold on;
for k = 1:i
    angle = results(k).angle;
    yaw = results(k).yaw;
    time = results(k).time;
    plot(time, yaw, 'Color', colors{mod(k-1,13) + 1}, 'LineWidth', 5)
    if mod(angle,1) == 0
        legendEntries(k) = sprintf('%d°', angle);
    else
        legendEntries(k) = sprintf('%.1f°', angle);
    end
end
hold off;
xlabel("Time (s)","FontSize",20)
ylabel("Yaw (rad)","FontSize",20)
ylim([-pi pi])
yticks([-pi, -pi/2, 0, pi/2, pi])
yticklabels(["-\pi", "-\pi/2", "0", "\pi/2", "\pi"])
set(gcf,'color',[1 1 1]);
set(gca,'color',[0.95 0.95 0.95],'FontSize',25);
legend(legendEntries, 'Location', 'best', 'FontSize', 10)
grid on

%% Angular Rates

% Roll
figure
hold on;
for k = 1:i
    angle = results(k).angle;
    roll = results(k).rollRate;
    [~,j] = max(results(k).altitude);
    avgRR = roll(j);
    time = results(k).time;
    plot(time, roll, 'Color', colors{mod(k-1,13) + 1}, 'LineWidth', 5)
    if mod(angle,1) == 0
        legendEntries(k) = sprintf('%d°: %.1fcyc/s', angle, avgRR / (2*pi));
    else
        legendEntries(k) = sprintf('%.1f°: %.1fcyc/s', angle, avgRR / (2*pi));
    end
end
hold off;
xlabel("Time (s)","FontSize",20)
ylabel("Roll Rate (rad/s)","FontSize",20)
set(gcf,'color',[1 1 1]);
set(gca,'color',[0.95 0.95 0.95],'FontSize',25);
legend(legendEntries, 'Location', 'best', 'FontSize', 10)
grid on

% Pitch
figure
hold on;
for k = 1:i
    angle = results(k).angle;
    pitch = results(k).pitchRate;
    time = results(k).time;
    plot(time, pitch, 'Color', colors{mod(k-1,13) + 1}, 'LineWidth', 5)
    if mod(angle,1) == 0
        legendEntries(k) = sprintf('%d°', angle);
    else
        legendEntries(k) = sprintf('%.1f°', angle);
    end
end
hold off;
xlabel("Time (s)","FontSize",20)
ylabel("Pitch Rate (rad/s)","FontSize",20)
set(gcf,'color',[1 1 1]);
set(gca,'color',[0.95 0.95 0.95],'FontSize',25);
legend(legendEntries, 'Location', 'best', 'FontSize', 10)
grid on

% Yaw
figure
hold on;
for k = 1:i
    angle = results(k).angle;
    yaw = results(k).yawRate;
    time = results(k).time;
    plot(time, yaw, 'Color', colors{mod(k-1,13) + 1}, 'LineWidth', 5)
    if mod(angle,1) == 0
        legendEntries(k) = sprintf('%d°', angle);
    else
        legendEntries(k) = sprintf('%.1f°', angle);
    end
end
hold off;
xlabel("Time (s)","FontSize",20)
ylabel("Yaw Rate (rad)","FontSize",20)
set(gcf,'color',[1 1 1]);
set(gca,'color',[0.95 0.95 0.95],'FontSize',25);
legend(legendEntries, 'Location', 'best', 'FontSize', 10)
grid on

%% Important Angles

% Gamma
figure
hold on;
for k = 1:i
    angle = results(k).angle;
    gamma = results(k).gamma;
    time = results(k).time;
    plot(time, gamma, 'Color', colors{mod(k-1,13) + 1}, 'LineWidth', 5)
    if mod(angle,1) == 0
        legendEntries(k) = sprintf('%d°', angle);
    else
        legendEntries(k) = sprintf('%.1f°', angle);
    end
end
hold off;
xlabel("Time (s)","FontSize",20)
ylabel("Flight Path Angle (rad)","FontSize",20)
ylim([-pi/2 pi/2])
yticks([-pi/2, 0, pi/2])
yticklabels(["-\pi/2", "0", "\pi/2"])
set(gcf,'color',[1 1 1]);
set(gca,'color',[0.95 0.95 0.95],'FontSize',25);
legend(legendEntries, 'Location', 'best', 'FontSize', 10)
grid on

% Chi
figure
hold on;
for k = 1:i
    angle = results(k).angle;
    chi = results(k).chi;
    time = results(k).time;
    plot(time, chi, 'Color', colors{mod(k-1,13) + 1}, 'LineWidth', 5)
    if mod(angle,1) == 0
        legendEntries(k) = sprintf('%d°', angle);
    else
        legendEntries(k) = sprintf('%.1f°', angle);
    end
end
hold off;
xlabel("Time (s)","FontSize",20)
ylabel("Horiz. Azimuth (rad)","FontSize",20)
ylim([-pi/2 pi/2])
yticks([-pi/2, 0, pi/2])
yticklabels(["-\pi/2", "0", "\pi/2"])
set(gcf,'color',[1 1 1]);
set(gca,'color',[0.95 0.95 0.95],'FontSize',25);
legend(legendEntries, 'Location', 'best', 'FontSize', 10)
grid on

% Alpha
figure
hold on;
for k = 1:i
    angle = results(k).angle;
    alpha = results(k).alpha;
    time = results(k).time;
    plot(time, alpha, 'Color', colors{mod(k-1,13) + 1}, 'LineWidth', 5)
    if mod(angle,1) == 0
        legendEntries(k) = sprintf('%d°', angle);
    else
        legendEntries(k) = sprintf('%.1f°', angle);
    end
end
hold off;
xlabel("Time (s)","FontSize",20)
ylabel("Angle of Attack (rad)","FontSize",20)
ylim([-pi/2 pi])
yticks([-pi/2, 0, pi/2, pi])
yticklabels(["-\pi/2", "0", "\pi/2", "\pi"])
set(gcf,'color',[1 1 1]);
set(gca,'color',[0.95 0.95 0.95],'FontSize',25);
legend(legendEntries, 'Location', 'best', 'FontSize', 10)
grid on

%% Other

% Dynamic Pressure
figure
hold on;
for k = 1:i
    angle = results(k).angle;
    alt = results(k).altitude;
    [~, idx] = max(alt);
    vel = results(k).velocity;
    qbar = 0.5*(1.225*exp(-max(alt,0)/8500)).*(vel.^2);
    maxQ = max(qbar(1:idx)) / 1000;
    time = results(k).time;
    plot(time, qbar, 'Color', colors{mod(k-1,13) + 1}, 'LineWidth', 5)
    if mod(angle,1) == 0
        legendEntries(k) = sprintf('%d°: Max Q %.2fkPa', angle, maxQ);
    else
        legendEntries(k) = sprintf('%.1f°: Max Q %.2fkPa', angle, maxQ);
    end
end
hold off;
xlabel("Time (s)","FontSize",20)
xlim([0 100])
ylabel("Dynamic Pressure (Pa)","FontSize",20)
set(gcf,'color',[1 1 1]);
set(gca,'color',[0.95 0.95 0.95],'FontSize',25);
legend(legendEntries, 'Location', 'best', 'FontSize', 10)
grid on

% Fuel Mass
figure
hold on;
for k = 1:i
    angle = results(k).angle;
    m_f = results(k).fuel_mass;
    time = results(k).time;
    [~,t] = min(m_f);
    plot(time, m_f, 'Color', colors{mod(k-1,13) + 1}, 'LineWidth', 5)
    if mod(angle,1) == 0
        legendEntries(k) = sprintf('%d°: Burnout at %.2fs', angle, time(t));
    else
        legendEntries(k) = sprintf('%.1f°: Burnout at %.2fs', angle, time(t));
    end
end
hold off;
xlabel("Time (s)","FontSize",20)
xlim([0 50])
ylabel("Fuel Mass (kg)","FontSize",20)
set(gcf,'color',[1 1 1]);
set(gca,'color',[0.95 0.95 0.95],'FontSize',25);
legend(legendEntries, 'Location', 'best', 'FontSize', 10)
grid on

% Mach Number
figure
hold on;
for k = 1:i
    angle = results(k).angle;
    mach = results(k).mach;
    maxM = max(mach);
    time = results(k).time;
    plot(time, mach, 'Color', colors{mod(k-1,13) + 1}, 'LineWidth', 5)
    if mod(angle,1) == 0
        legendEntries(k) = sprintf('%d°: Mach %0.2f', angle, maxM);
    else
        legendEntries(k) = sprintf('%.1f°: Mach %0.2f', angle, maxM);
    end
end
hold off;
xlabel("Time (s)","FontSize",20)
ylabel("Mach Number","FontSize",20)
set(gcf,'color',[1 1 1]);
set(gca,'color',[0.95 0.95 0.95],'FontSize',25);
legend(legendEntries, 'Location', 'best', 'FontSize', 10)
grid on



end