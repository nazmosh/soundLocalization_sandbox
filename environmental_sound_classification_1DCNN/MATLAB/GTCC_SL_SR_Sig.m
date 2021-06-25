close all;
clear;
clc;
%=========================================================================%
%*************************************************************************%
%*********** This code has been written by Awny M. El-Mohandes ***********%
%*************************************************************************%
%=========================================================================%
% Simulating HRTF Filtering of wave files
%=========================================================================%
% Reading the HRTF from ITA SOFA Dataset
%=========================================================================%
PathOfDB = 'C:\Awny_Work\McMaster\Earables\Simulation\Mine\HRTFDatabase';
SOFAfile = fullfile(PathOfDB, 'SOFA', 'MRT10.sofa');
ObjFull = SOFAload(SOFAfile);
hrtfData = ObjFull.Data.IR;
Fs_Of_hrtf = ObjFull.Data.SamplingRate;
sourcePosition = ObjFull.SourcePosition;
leftIR = squeeze(hrtfData(:,1,:));
rightIR = squeeze(hrtfData(:,2,:));
%=========================================================================%
% Reading Mono .wav audio files
%=========================================================================%
AudioPath = 'C:\Awny_Work\McMaster\Earables\pysim\MyData\Source';
Sound_Type = [{'Breaking'}, {'Bark'}, {'Blah'}, {'Bird'}, {'Speech'}];
Data_Left = [];
Data_Right = [];
Data_PhaT = [];
Data_Lable = [];
for k = 1 : length(Sound_Type)
    filename = sprintf('%s_M.wav',Sound_Type{k});
    SPath = fullfile(AudioPath, filename);
    [audioIn, Fs] = audioread(SPath);
    audioIn = audioIn ./ (max(abs(audioIn)));
%=========================================================================%
% Create two dsp.FIRFilter objects and specify the filter coefficients
% using the head-related transfer function interpolated impulse responses.
%=========================================================================%    
    for i = 1 : size(leftIR, 1)
        sr = dsp.SignalSource;
        sr.Signal = audioIn;
        sink_L = dsp.SignalSink;
        sink_R = dsp.SignalSink;
        leftFilter = dsp.FIRFilter('Numerator',leftIR(i,:));
        rightFilter = dsp.FIRFilter('Numerator',rightIR(i,:));
        while ~isDone(sr)
            input = sr();
            filteredOutput_L = leftFilter(input);
            sink_L(filteredOutput_L);
            filteredOutput_R = rightFilter(input);
            sink_R(filteredOutput_R);
        end
        Temp_left = sink_L.Buffer;
        Temp_right = sink_R.Buffer;
        y = [Temp_left, Temp_right];
        [Feature_1, Feature_2, Feature_3] = Sig_GTCC(y, Fs);
        xyz = sourcePosition(i, :);
        Data_Left = [Data_Left , Feature_1];
        Data_Right = [Data_Right , Feature_2];
        Data_PhaT = [Data_PhaT ; Feature_3'];
        Data_Lable = [Data_Lable ; xyz];
    end
end
%=========================================================================%
% Save the Features for Training, Validation, and Testing
%=========================================================================%
F_L = Data_Left;
T = table(F_L);
writetable(T,'gtccleft.csv','Delimiter',',')
F_R = Data_Right;
T = table(F_R);
writetable(T,'gtccright.csv','Delimiter',',')
F_PhaT = Data_PhaT;
T = table(F_PhaT);
writetable(T,'PhaT.csv','Delimiter',',')
x_axis = Data_Lable(:, 1);
y_axis = Data_Lable(:, 2);
z_axis = Data_Lable(:, 3);
T = table(x_axis , y_axis , z_axis);
writetable(T,'gtcclable.csv','Delimiter',',')