% sift_rot_id.m
% (C) Toshihiko YAMASAKI
% �{�v���O�������g�p�������Ƃɂ�邢���Ȃ��Q�A���Q���ӔC�͂Ƃ�܂���
% �e���̐ӔC�ɂ����Ďg�p���Ă��������B
function id=sift_rot_id(theta)
if -pi/8 <= theta && theta < pi/8
    id=1;
elseif pi/8 <= theta && theta < 3*pi/8
    id=2;
elseif 3*pi/8 <= theta && theta < 5*pi/8
    id=3;
elseif 5*pi/8 <= theta && theta < 7*pi/8
    id=4;
elseif 7*pi/8 <= theta || theta < -7*pi/8
    id=5;
elseif -7*pi/8 <= theta && theta < -5*pi/8
    id=6;
elseif -5*pi/8 <= theta && theta < -3*pi/8
    id=7;
elseif -3*pi/8 <= theta && theta < -pi/8
    id=8;
end

