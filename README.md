# hf_voice

**One capability bit from GBT V8, packaged standalone.** No. 338 of 341,
`voice` domain (Voice).

<p>
<img alt="python" src="https://img.shields.io/badge/python-3.9%2B-blue">
<img alt="license" src="https://img.shields.io/badge/license-MIT-green">
<img alt="deps" src="https://img.shields.io/badge/runtime%20dependencies-0-brightgreen">
</p>

> Hugging Face 歌声/语音（**3 臂轮询**，主人令 2026-09-28「把插件连接好部署语音…安装 3 个这个插件轮询使用避免卡壳」）：本机零算力跑不动歌声合成（语音中枢 v2.0 一手实测）⇒ 真唱走云。**3 臂（hf-1/2/3）按轮询 + 冷却换道**用（与 key_gateway 同一纪律）：单臂连续失败 3 次冷却 300s、自动投下一臂 ⇒ 避免单点卡壳。**出网硬钉**：只 https + 主机白名单（HF 三个官方域）+ 显式拒私有/环回/保留地址 + 拒重定向；**只回掩码**，密钥只走 env:/vault: 引用。`sing` 过 external_llm 门；模型表全部**未验**（本机无 token）。op=status/arms/models/sing/rotate/verify/where

That description is copied verbatim from the registry. `tests/test_spec.py` pins it,
so documentation drift fails the build instead of shipping quietly.

## What this package actually is

It is the **contract** for one capability: its name, its parameters, the values it
accepts, and whether it can change state that cannot be restored. It is not the
implementation — that lives in the runtime this bit was extracted from.

So `run()` goes through a narrow `Backend` protocol, and the default backend is a
stub that **says so**:

```
status="validated"   backend="stub"   data={"executed": false}
```

Never `status="ok"`. A stub that reports success is worse than no stub, because the
caller stops looking for the real thing.

## Install

```bash
git clone https://github.com/gbtweilai-star/gbt-hf-voice.git
cd gbt-hf-voice
python -m pip install -e ".[dev]"
```

## Use

```bash
python -m gbt_hf_voice info                  # capability card
python -m gbt_hf_voice spec --json           # machine-readable contract
python -m gbt_hf_voice check --payload '{}'
python -m gbt_hf_voice run   --payload '{}'
```

Real `info` output from this machine:

```text
hf_voice  (voice)  v1.0.0
----------------------------------------
Hugging Face 歌声/语音（**3 臂轮询**，主人令 2026-09-28「把插件连接好部署语音…安装 3 个这个插件轮询使用避免卡壳」）：本机零算力跑不动歌声合成（语音中枢 v2.0 一手实测）⇒ 真唱走云。**3 臂（hf-1/2/3）按轮询 + 冷却换道**用（与 key_gateway 同一纪律）：单臂连续失败 3 次冷却 300s、自动投下一臂 ⇒ 避免单点卡壳。**出网硬钉**：只 https + 主机白名单（HF 三个官方域）+ 显式拒私有/环回/保留地址 + 拒重定向；**只回掩码**，密钥只走 env:/vault: 引用。`sing` 过 external_llm 门；模型表全部**未验**（本机无 token）。op=status/arms/models/sing/rotate/verify/where

gated      : False
external   : False
multi-op   : True
params     : (none)
values     : status, arms, models, sing, rotate, verify, where
```

Wire a real implementation:

```python
from gbt_hf_voice import run

class MyBackend:
    name = "my-backend"
    def invoke(self, cap, payload):
        return {"cap": cap, "handled": sorted(payload)}

result = run({}, backend=MyBackend())
assert result.status == "ok"
```

## Parameters

| name | required | notes |
|---|---|---|
| — | no | the registry declares no required parameters |

Registry hint (`params_hint`): (empty)

**注册表登记的取值 / 子动作（7 个）**：`status`、`arms`、`models`、`sing`、`rotate`、`verify`、`where`

Types are deliberately absent: the registry does not declare them, and an invented
type is worse than no type, because callers believe it.

## Boundaries

- Not gated: the registry marks this bit `safe: true`.
- No external service dependency declared.
- Multi-op (`multi_op: true`): several sub-actions share one name — read `op` before calling.
- No implementation ships here. Bring a backend; the protocol is one method.

## What this is not

Not a wrapper around a hosted API. Not a model. Not a promise that calling it does
anything on its own. It is the typed seam plus the validation, which is the part that
stays correct even when the implementation changes.

## Tests

```bash
python -m pytest
```

```text
20 passed, 3 skipped in 0.09s
```

## Provenance

| field | value |
|---|---|
| capability | `hf_voice` |
| domain | `voice` |
| handler | `hf_voice` |
| safe | `True` (gated = `False`) |
| external | `False` |
| atlas page | [voice/hf_voice](https://github.com/gbtweilai-star/gbt-caps/blob/main/caps/voice/hf_voice.md) |
| full index | [https://github.com/gbtweilai-star/gbt-caps](https://github.com/gbtweilai-star/gbt-caps) |

The parent README says 348 capabilities; an AST pass over the registry enumerates
`341 + 0 unimplemented + 0 disabled = 341`. The extra 7 are historical duplicates.
Numbering here follows 341 and matches the `gbt-caps` index one-to-one.

## License

MIT.
