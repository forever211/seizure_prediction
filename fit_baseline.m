function [W_baseline,H_baseline,W_model_baseline,H_model_baseline,W_parameters_baseline,H_parameters_baseline,Models_baseline] = fit_baseline(path_directory,baseline_directory,files,num_files,num_channels,num_windows,sample,run_nr)
%% loading and setting the parameters

time_order = 2;
freq_order = 6;
nnmf_order = 1;

load(strcat(path_directory,baseline_directory,'spectrograms_baseline/',files(1).name)) % for getting indices of freq.bins of 50Hz component
mean_Spec = mean(spectrogram_baseline_1(1,:,:),1);
kill_IDX = find(mean(mean_Spec)==0);

num_freq_bins = size(mean_Spec,3)-size(kill_IDX,1);

W_baseline = zeros(num_channels, num_windows);
H_baseline = zeros(num_channels, num_freq_bins);

W_model_baseline = zeros(num_channels, num_windows);
H_model_baseline = zeros(num_channels, num_freq_bins);

W_parameters_baseline = zeros(num_channels, time_order+1);
H_parameters_baseline = zeros(num_channels, freq_order+3);

Models_baseline = zeros(num_channels, num_windows, num_freq_bins);

%% preprocessing

for i = 1:num_files

    fprintf('%d out of %d periods\n',i,num_files)

    load(strcat(path_directory,baseline_directory,'spectrograms_baseline/',files(i).name))

    spectrogram_baseline_1(:,:,kill_IDX) = [];       % get rid of the 50Hz component

    for IDXC = 1:num_channels

        temp = spectrogram_baseline_1(IDXC,:,:);

        % Compute the mean and median for eye inspection only
        % for baseline
        mean_baseline_Spec   = squeeze(mean(temp,1));
        mean_baseline_SpecR  = squeeze(trimmean(temp,75,1));
        median_baseline_Spec = squeeze(median(temp,1));


        %% saving

        savename_part = strsplit(files(i).name,'spectrogram_');

        savename_baseline = strcat(path_directory,baseline_directory,'baseline_spec/',run_nr,'/',sample,'/mean_baseline_SpecR_',savename_part{2});

        save(savename_baseline,'sample','run_nr','patient_id','mean_baseline_SpecR')


        %% nnmf and modelling

        % Do the nnmf for the two cases.
        % Important is that time is modeled only with second order - that makes
        % interpretation very easy.
        % The fre is modelled with non linerly spaces cubic splines to consider the
        % frequency resolution that deceases for higher freqs.
        % The results is a prototype TF image based on the modelled nnmf.

        % The results is a prototype TF image based on the modelled nnmf.
        % If you have nnmf_order=1 you get one model.
        % For nnmf_order=2 you get 4. I have the feeling 1 works good; 4 doesn't.

        % baseline
        [w_baseline,h_baseline] = nnmf(mean_baseline_SpecR,nnmf_order);       % cp1 (W) is a time component; cp2 (H) is a frequency component
        [w_model_baseline,w_parameters_baseline] = fit_polynominal(w_baseline,time_order);
        [h_model_baseline,h_parameters_baseline] = fit_splines(h_baseline',freq_order,0);

        % Models_Baseline contains a single average model per periods for 1 IDXC channel
        IDXM3 = 0;
        for IDXM1 = 1:size(w_baseline,2)           % it's always 1, but IDXM1 is for model one == x_model
            for IDXM2 = 1:size(h_baseline,1)       % it's always 1, but IDXM2 is for two one == y_model
                IDXM3 = IDXM3 +1;           % it's always 1, but IDXM3 is for three one == Models_Baseline
                Models_Baseline(IDXM3,:,:) = (w_model_baseline(IDXM1,:)'*h_model_baseline(IDXM2,:));   % prototype tf model for baseline
            end
        end

        W_baseline(IDXC,:) = w_baseline';
        H_baseline(IDXC,:) = h_baseline;

        W_model_baseline(IDXC,:) = w_model_baseline;
        H_model_baseline(IDXC,:) = h_model_baseline;

        W_parameters_baseline(IDXC,:) = w_parameters_baseline;
        H_parameters_baseline(IDXC,:) = h_parameters_baseline;

        Models_baseline(IDXC,:,:) = Models_Baseline;

    end
    %% saving

    savename_part = strsplit(files(i).name,'spectrogram_');

    savename_baseline = strcat(path_directory,baseline_directory,'models_baseline/',run_nr,'/',sample,'/Model_',savename_part{2});

    save(savename_baseline,'sample','run_nr','patient_id','W_baseline','H_baseline','W_model_baseline','H_model_baseline','W_parameters_baseline','H_parameters_baseline','Models_baseline')

end

end