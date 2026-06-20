# MultiCloneBERT

Code for the paper:

**MultiCloneBERT: A Novel Semantic Code Clone Detection Mechanism Leveraging Graph-Based Large Language Model**

MultiCloneBERT is a multi-class code clone detection framework based on GraphCodeBERT. It classifies a pair of Java code fragments into four clone categories: Type-1, Type-2, Type-3, and Type-4. The implementation combines source-code token representation with data-flow graph information extracted by Tree-sitter and uses a GraphCodeBERT encoder followed by a lightweight classification head.

## Core files

The main paper reproduction files are:

```text
run.py
model.py
parser/
evaluator/
check.sh
get_result.sh
requirements.txt
```

Additional scripts such as DistilBERT, CodeT5+, CodeLLaMA, and unlearning scripts are later experimental additions and are not required to reproduce the main MultiCloneBERT paper result.

## Dataset

The dataset is not stored directly in this repository because of its size. Download it from:

```text
https://drive.google.com/drive/folders/1mTlPzLTNeEpXntteV6u9mvC4HEsUdfM7?usp=sharing
```

Place the dataset under:

```text
dataset/Multiclass/
```

Expected layout:

```text
dataset/
└── Multiclass/
    ├── data.jsonl
    ├── train_100000.txt
    └── test_100000.txt
```

`data.jsonl` stores function bodies indexed by function id:

```json
{"idx": "13653451", "func": "public static ..."}
```

Each split file stores clone pairs and labels:

```text
function_id_1<TAB>function_id_2<TAB>label
```

Labels:

```text
0 = Type-1 clone
1 = Type-2 clone
2 = Type-3 clone
3 = Type-4 clone
```

## Environment

Create a clean environment:

```bash
conda create -n multiclonebert python=3.10 -y
conda activate multiclonebert
pip install -r requirements.txt
```

Build the Tree-sitter parser library:

```bash
cd parser
bash build.sh
cd ..
test -f parser/my-languages.so
```

If `parser/my-languages.so` is missing, `run.py` will fail when loading the parser.

## Quick check

Run a one-epoch check:

```bash
bash check.sh
```

This verifies the environment, parser, dataset, model download, training loop, and evaluation loop.

## Training

To train the main GraphCodeBERT-based MultiCloneBERT model on the 100,000-sample setting:

```bash
mkdir -p graphcodebert_100000

python run.py \
    --output_dir=graphcodebert_100000 \
    --config_name=microsoft/graphcodebert-base \
    --model_name_or_path=microsoft/graphcodebert-base \
    --tokenizer_name=microsoft/graphcodebert-base \
    --do_train \
    --do_eval \
    --train_data_file=dataset/Multiclass/train_100000.txt \
    --eval_data_file=dataset/Multiclass/test_100000.txt \
    --test_data_file=dataset/Multiclass/test_100000.txt \
    --epochs 10 \
    --code_length 512 \
    --data_flow_length 128 \
    --train_batch_size 4 \
    --eval_batch_size 4 \
    --learning_rate 2e-5 \
    --max_grad_norm 1.0 \
    --evaluate_during_training \
    --seed 123456 2>&1 | tee graphcodebert_100000/train_eval.log
```

The best checkpoint is saved to:

```text
graphcodebert_100000/checkpoint-best-f1/model.bin
```

## Evaluation

If a trained checkpoint already exists, run:

```bash
bash get_result.sh
```

or explicitly:

```bash
python run.py \
    --output_dir=graphcodebert_100000 \
    --config_name=microsoft/graphcodebert-base \
    --model_name_or_path=microsoft/graphcodebert-base \
    --tokenizer_name=microsoft/graphcodebert-base \
    --do_eval \
    --train_data_file=dataset/Multiclass/train_100000.txt \
    --eval_data_file=dataset/Multiclass/test_100000.txt \
    --test_data_file=dataset/Multiclass/test_100000.txt \
    --epochs 10 \
    --code_length 512 \
    --data_flow_length 128 \
    --train_batch_size 4 \
    --eval_batch_size 4 \
    --learning_rate 2e-5 \
    --max_grad_norm 1.0 \
    --evaluate_during_training \
    --seed 123456 2>&1 | tee graphcodebert_100000/graphcodebert_100000_eval.log
```

The evaluation reports macro precision, macro recall, macro F1, accuracy, and macro accuracy. It also writes a confusion matrix to:

```text
graphcodebert_100000/confusion_matrix.svg
```

## Raw predictions

To write predictions:

```bash
python run.py \
    --output_dir=graphcodebert_100000 \
    --config_name=microsoft/graphcodebert-base \
    --model_name_or_path=microsoft/graphcodebert-base \
    --tokenizer_name=microsoft/graphcodebert-base \
    --do_test \
    --train_data_file=dataset/Multiclass/train_100000.txt \
    --eval_data_file=dataset/Multiclass/test_100000.txt \
    --test_data_file=dataset/Multiclass/test_100000.txt \
    --code_length 512 \
    --data_flow_length 128 \
    --eval_batch_size 4 \
    --seed 123456
```

Predictions are written to:

```text
graphcodebert_100000/predictions.txt
```

## Standalone evaluator

```bash
python evaluator/evaluator.py \
    --answers evaluator/answers.txt \
    --predictions evaluator/predictions.txt
```

## Paper setting

The paper setting uses Java functions from BigCloneBench/IJaDataset, four clone classes, GraphCodeBERT, code length 512, DFG length 128, batch size 4, learning rate `2e-5`, Adam optimization, and seed `123456`.

The 100,000-sample setting is balanced across the four clone types. The paper describes 72,000 samples for fine-tuning, 8,000 for validation, and 20,000 for evaluation. Before reporting final results, verify that the downloaded split files match the intended paper split.

## Large-file policy

Do not commit datasets or trained checkpoints to GitHub. Use Google Drive for large artifacts.

Before committing:

```bash
find . -type f -size +50M
git status --short
git ls-files | less
```

