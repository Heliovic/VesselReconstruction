clc;
clear;
parent_folder = './Ѫ����Ƭ/';
img_num = 100;
img_size = 512;
img_extension = '.bmp';
img_cell = cell(1, img_num);
img_feature = zeros(3, 100);
for i = 1:img_num
    A = imread([parent_folder, num2str(i - 1), img_extension]);
    A = ~A; %����֣���ȡ���������߿�����Ӱ������Բ�ж�
%     AA = bwperim(A,8);
%     imshow(AA);
%     max_inscribed_circle(im2uint8(AA), 1);
    img_cell{1, i} = bwperim(A, 8) .* 255;  %ת�Ҷ�ͼ����������
    [R, cx, cy] = max_inscribed_circle(img_cell{1, i}, 0);
    img_feature(1, i) = R;
    img_feature(2, i) = cx;
    img_feature(3, i) = cy;
end

vessel_radius = max(img_feature(1, :)) / 2; %Ѫ�ܰ뾶��ȡ�����ȡƽ����

zz = 1:1:100;
yy = img_feature(2, :);
xx = img_feature(3, :);

mmx = min(xx):max(xx);

% ѵ��x-y
p = xx; % ÿ��Ϊһ��ѵ������
t = yy;

%����BP������
netxy = newff(p,t,5);

%���ѵ������
netxy.trainParam.epochs = 5000;

%�����ѧϰ����
netxy.trainParam.lr = 0.1;

%ѵ��������Ҫ�ﵽ��Ŀ�����
netxy.trainParam.goal = 1e-3;

%��������������6�ε�����û�仯����matlab��Ĭ����ֹѵ����Ϊ���ó���������У�����������ȡ����������
netxy.divideFcn = '';

%��ʼѵ������
netxy = train(netxy, p, t);

neu_yy = sim(netxy, mmx);

% plot(mmx, neu_yy);
% title('x-y');
% xlabel('x'),ylabel('y');





% ѵ��x-z
pp = xx;  % ÿ��Ϊһ��ѵ������
tt = zz;

netxz = newff(pp,tt,5);

netxz.trainParam.epochs = 5000;

netxz.trainParam.lr = 0.1;

netxz.trainParam.goal = 1e-3;

netxz.divideFcn = '';

%��ʼѵ������
netxz = train(netxz, pp, tt);

neu_zz = sim(netxz, mmx);

% plot(xx,zz);

% plot3(xx, yy, zz);
% xlabel('x'),ylabel('y'),zlabel('z');

min_x = min(xx);
max_x = max(xx);

xx = min_x:max_x;


subplot(2,2,1);
plot3(xx, neu_yy, neu_zz);
title('Ѫ��������');
xlabel('x'),ylabel('y'),zlabel('z');

subplot(2,2,2);
plot(xx, neu_yy);
title('x-y');
xlabel('x'),ylabel('y');

subplot(2,2,3);
plot(neu_yy, neu_zz);
title('y-z');
xlabel('y'),ylabel('z');

subplot(2,2,4);
plot(xx, neu_zz);
title('x-z');
xlabel('x'),ylabel('z');

% plot(xx, yyy);
% plot(yyy, zzz);
% plot(xx, zzz);


