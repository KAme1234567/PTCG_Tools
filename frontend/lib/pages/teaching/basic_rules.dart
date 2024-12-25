import 'package:flutter/material.dart';

class BasicRules extends StatefulWidget {
  const BasicRules({super.key});

  @override
  _BasicRulesState createState() => _BasicRulesState();
}

class _BasicRulesState extends State<BasicRules> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            '基本規則',
            style: TextStyle(fontSize: 32),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              '遊戲結構',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '1. 遊戲目標\n- 收集所有獎勵卡（Prize Cards），或擊敗對手的最後一隻寶可夢，或者當對手牌庫無牌可抽時勝利。\n\n2. 牌組構成\n- 每副牌組限 60 張牌，且同名卡片最多 4 張。\n- 必須包含基本寶可夢卡，以保證能夠啟動遊戲。\n\n3. 卡牌類型\n- 寶可夢卡：用於戰鬥，包括基本寶可夢、進化寶可夢、EX、V、GX 等。\n- 能量卡：供給寶可夢使用技能的資源，分為基本能量和特殊能量。\n- 訓練家卡：支持策略，包括道具、支援者和體育場卡。',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '遊戲過程',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '1. 準備階段\n- 每位玩家洗牌並抽 7 張牌作為手牌。\n- 確認是否有基本寶可夢：\n  - 若無基本寶可夢，需展示手牌，洗回牌庫並重新抽取 7 張。\n  - 對手可抽取 1 張額外卡作為懲罰。\n- 將 6 張獎勵卡面朝下放在場外。\n\n2. 布置寶可夢\n- 選擇一隻基本寶可夢作為主戰寶可夢。\n- 其餘基本寶可夢可放置於備戰區（最多 5 隻）。\n\n3. 投擲硬幣\n- 決定先攻或後攻。先攻玩家不能在第一回合攻擊。',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '回合流程',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '1. 抽牌階段\n- 從牌庫頂抽一張卡。若無卡可抽，則直接判負。\n\n2. 基礎操作\n- 放置寶可夢：將基本寶可夢卡從手牌放至備戰區。\n- 進化寶可夢：將進化卡疊放於符合條件的主戰或備戰寶可夢上（寶可夢需已在場 1 回合以上）。\n- 附加能量：每回合可以為一隻寶可夢附加 1 張能量卡。\n- 使用訓練家卡：根據效果執行行動，支援者和體育場卡每回合僅能使用 1 次。\n- 退場或交換：透過技能或卡牌效果切換主戰寶可夢（需支付退場費用）。\n\n3. 攻擊階段\n- 宣告攻擊並支付所需能量。\n- 根據對手主戰寶可夢的弱點或抗性調整傷害：\n  - 弱點：通常為雙倍傷害。\n  - 抗性：減少固定傷害。\n- 若對手寶可夢受到的傷害超過其剩餘血量，則擊倒該寶可夢，將其移至棄牌堆。\n- 擊倒寶可夢後抽取相應的獎勵卡。\n\n4. 結束回合\n- 宣告回合結束，輪到對手操作。',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '特殊情況',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '1. 異常狀態\n- 中毒：每回合結束時受到固定傷害（通常為 10 點）。\n- 麻痺：無法攻擊或退場，持續 1 回合。\n- 睡眠：無法攻擊或退場，每回合投擲硬幣判定是否甦醒。\n- 燒傷：在每位玩家回合結束時受到固定傷害（通常為 20 點），並需要進行硬幣判定。\n\n2. 寶可夢死亡\n- 若主戰寶可夢被擊倒，必須立刻選擇一隻備戰寶可夢替代上場。\n- 若無備戰寶可夢且主戰寶可夢死亡，直接判負。\n\n3. 重複效應\n- 若多個效果同時發生，需按先後順序結算，並優先執行主動技能效果。\n\n4. 技能描述矛盾\n- 若技能文本與規則矛盾，則以技能文本為準。\n\n5. 無效判定\n- 某些技能或卡片會免疫特定類型的效果，如「防禦所有屬性技能」。',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
