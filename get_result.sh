python run.py \
    --output_dir=blomb_blomb \
    --config_name=microsoft/graphcodebert-base \
    --model_name_or_path=microsoft/graphcodebert-base \
    --tokenizer_name=microsoft/graphcodebert-base \
    --do_eval \
    --train_data_file=dataset/Multiclass/train_100000.txt \
    --eval_data_file=dataset/Multiclass/test_100000.txt \
    --test_data_file=dataset/Multiclass/test_100000.txt \
    --epoch 10 \
    --code_length 512 \
    --data_flow_length 128 \
    --train_batch_size 4 \
    --eval_batch_size 4 \
    --learning_rate 2e-5 \
    --max_grad_norm 1.0 \
    --evaluate_during_training \
    --seed 123456 2>&1| tee blomb_blomb/blomb_blomb.log

# python run.py \
#     --output_dir=saved_models_50_epoch_5000_samples \
#     --config_name=microsoft/graphcodebert-base \
#     --model_name_or_path=microsoft/graphcodebert-base \
#     --tokenizer_name=microsoft/graphcodebert-base \
#     --do_eval \
#     --train_data_file=dataset/Multiclass/train_5000.txt \
#     --eval_data_file=dataset/Multiclass/test_5000.txt \
#     --test_data_file=dataset/Multiclass/test_5000.txt \
#     --epoch 1 \
#     --code_length 512 \
#     --data_flow_length 128 \
#     --train_batch_size 4 \
#     --eval_batch_size 4 \
#     --learning_rate 2e-5 \
#     --max_grad_norm 1.0 \
#     --evaluate_during_training \
#     --seed 123456 2>&1| tee saved_models_50_epoch_5000_samples/eval_5000_samples.log

# python run.py \
#     --output_dir=saved_models_50_epoch_20000_samples \
#     --config_name=microsoft/graphcodebert-base \
#     --model_name_or_path=microsoft/graphcodebert-base \
#     --tokenizer_name=microsoft/graphcodebert-base \
#     --do_eval \
#     --train_data_file=dataset/Multiclass/train_20000.txt \
#     --eval_data_file=dataset/Multiclass/test_20000.txt \
#     --test_data_file=dataset/Multiclass/test_20000.txt \
#     --epoch 1 \
#     --code_length 512 \
#     --data_flow_length 128 \
#     --train_batch_size 4 \
#     --eval_batch_size 4 \
#     --learning_rate 2e-5 \
#     --max_grad_norm 1.0 \
#     --evaluate_during_training \
#     --seed 123456 2>&1| tee saved_models_50_epoch_20000_samples/eval_20000_samples.log
