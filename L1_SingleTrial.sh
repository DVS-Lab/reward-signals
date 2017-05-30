#!/bin/sh


expdir=/Users/DVS/Dropbox/Projects/Rutgers/SocRewardAffInf/SocRewardTask_scan


for subj in 1002 1003 `seq 1005 1024`; do
	for r in 1 2 3 4; do
		mainout=${expdir}/fsl/${subj}
		mkdir -p $mainout
		#DATA=${mainout}/prestats${r}.feat/ICA_AROMA/denoised_func_data_nonaggr.nii.gz

		OUTPUT=${mainout}/L1_FB2_trials_${r}
		rm -rf $OUTPUT.feat

		evfiles=${expdir}/evfiles_SingleTrial_AffOnly/${subj}/run${r}
	
		EV1=${evfiles}/selfchoice${r}.txt
		EV2=${evfiles}/cselfchoice${r}.txt
		EV3=${evfiles}/partnerchoice${r}.txt
		EV4=${evfiles}/cpartnerchoice${r}.txt
		EV5=${evfiles}/lapseA${r}.txt
		EV6=${evfiles}/lapseB${r}.txt
		EV7=${evfiles}/FB1_run${r}.txt
		EV8=${evfiles}/cFB1_run${r}.txt
		
		for t in `jot -w "%02d" 40 1`; do
			eval T${t}=${evfiles}/FB2_trial${t}_run${r}.txt
		done

		TEMPLATE=${expdir}/SingleTrial_AffOnly_template.fsf
		sed -e 's@OUTPUT@'$OUTPUT'@g' \
		-e 's@EV1@'$EV1'@g' \
		-e 's@EV2@'$EV2'@g' \
		-e 's@EV3@'$EV3'@g' \
		-e 's@EV4@'$EV4'@g' \
		-e 's@EV5@'$EV5'@g' \
		-e 's@EV6@'$EV6'@g' \
		-e 's@EV7@'$EV7'@g' \
		-e 's@EV8@'$EV8'@g' \
		-e 's@T01@'$T01'@g' \
		-e 's@T02@'$T02'@g' \
		-e 's@T03@'$T03'@g' \
		-e 's@T04@'$T04'@g' \
		-e 's@T05@'$T05'@g' \
		-e 's@T06@'$T06'@g' \
		-e 's@T07@'$T07'@g' \
		-e 's@T08@'$T08'@g' \
		-e 's@T09@'$T09'@g' \
		-e 's@T10@'$T10'@g' \
		-e 's@T11@'$T11'@g' \
		-e 's@T12@'$T12'@g' \
		-e 's@T13@'$T13'@g' \
		-e 's@T14@'$T14'@g' \
		-e 's@T15@'$T15'@g' \
		-e 's@T16@'$T16'@g' \
		-e 's@T17@'$T17'@g' \
		-e 's@T18@'$T18'@g' \
		-e 's@T19@'$T19'@g' \
		-e 's@T20@'$T20'@g' \
		-e 's@T21@'$T21'@g' \
		-e 's@T22@'$T22'@g' \
		-e 's@T23@'$T23'@g' \
		-e 's@T24@'$T24'@g' \
		-e 's@T25@'$T25'@g' \
		-e 's@T26@'$T26'@g' \
		-e 's@T27@'$T27'@g' \
		-e 's@T28@'$T28'@g' \
		-e 's@T29@'$T29'@g' \
		-e 's@T30@'$T30'@g' \
		-e 's@T31@'$T31'@g' \
		-e 's@T32@'$T32'@g' \
		-e 's@T33@'$T33'@g' \
		-e 's@T34@'$T34'@g' \
		-e 's@T35@'$T35'@g' \
		-e 's@T36@'$T36'@g' \
		-e 's@T37@'$T37'@g' \
		-e 's@T38@'$T38'@g' \
		-e 's@T39@'$T39'@g' \
		-e 's@T40@'$T40'@g' \
		<$TEMPLATE> ${mainout}/L1_FB2_trials_${r}.fsf
		feat_model ${mainout}/L1_FB2_trials_${r}
	
		grep -v [A-Za-df-z] ${mainout}/L1_FB2_trials_${r}.mat | grep [0-9] > ${mainout}/trialdata_run${r}.mtx
		mv ${mainout}/L1_FB2_trials_${r}.png ${mainout}/trialdata_run${r}.png
		rm ${mainout}/L1_FB2_trials_${r}*
		
	done
done

