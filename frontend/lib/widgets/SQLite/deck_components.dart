// frontend\lib\widgets\SQLite\deck_components.dart
import 'package:flutter/material.dart';
import 'deck_DAta.dart'; // 導入 PTCG_DATA_API 組件

class deck_components extends StatefulWidget {
  final int deckId; // 接收 deckId

  const deck_components({super.key, required this.deckId});

  @override
  _deck_componentsState createState() => _deck_componentsState();
}

class _deck_componentsState extends State<deck_components> {
  final nameFocusNode = FocusNode(); // 名稱輸入框焦點
  final nameController = TextEditingController(); // 名稱搜索框控制器

  String selectedType = ''; // 新增的篩選屬性：卡片類型
  String selectedStage = '全部';
  String selectedWeakness = '無';
  String selectedResistance = '無';
  String selectedRetreatCost = '無限制';
  double hpValue = 150; // 預設 HP 值
  double minHP = 0;
  double maxHP = 500;

  @override
  void dispose() {
    // 清理資源
    nameFocusNode.dispose();
    nameController.dispose();
    super.dispose();
  }

  void _onSearchPressed() {
    // 清除所有焦點，避免 DOM 與 Flutter 焦點不一致
    FocusScope.of(context).unfocus();
    // 打印當前的查詢條件
    debugPrint(
        '查詢條件 - 名稱: ${nameController.text}, 階段: $selectedStage, 類型: $selectedType');
    setState(() {}); // 更新畫面
  }

  void _onFilterPressed() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            final List<Map<String, String>> types = [
              {
                'name': '無',
                'url':
                    'https://asia.pokemon-card.com/various_images/energy/Colorless.png'
              },
              {
                'name': '火',
                'url':
                    'https://asia.pokemon-card.com/various_images/energy/Fire.png'
              },
              {
                'name': '水',
                'url':
                    'https://asia.pokemon-card.com/various_images/energy/Water.png'
              },
              {
                'name': '草',
                'url':
                    'https://asia.pokemon-card.com/various_images/energy/Grass.png'
              },
              {
                'name': '電',
                'url':
                    'https://asia.pokemon-card.com/various_images/energy/Lightning.png'
              },
              {
                'name': '超',
                'url':
                    'https://asia.pokemon-card.com/various_images/energy/Psychic.png'
              },
              {
                'name': '格',
                'url':
                    'https://asia.pokemon-card.com/various_images/energy/Fighting.png'
              },
              {
                'name': '惡',
                'url':
                    'https://asia.pokemon-card.com/various_images/energy/Darkness.png'
              },
              {
                'name': '鋼',
                'url':
                    'https://asia.pokemon-card.com/various_images/energy/Metal.png'
              },
              {
                'name': '龍',
                'url':
                    'https://asia.pokemon-card.com/various_images/energy/Dragon.png'
              },
              {
                'name': '妖精',
                'url':
                    'https://asia.pokemon-card.com/various_images/energy/Fairy.png'
              }
            ];

            final List<String> stages = ['全部', '基礎', '1階進化', '2階進化'];
            final List<String> energyCost = [
              '無限制',
              '0',
              '1',
              '2',
              '3',
              '4',
              '5',
            ];

            return Container(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '篩選條件',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),

                    // 屬性篩選
                    const Text('選擇屬性：'),
                    GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 2.5,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: types.length,
                      itemBuilder: (context, index) {
                        final type = types[index];
                        return GestureDetector(
                          onTap: () {
                            setModalState(() {
                              selectedType = type['name']!;
                            });
                            setState(() {});
                          },
                          child: Row(
                            children: [
                              Image.network(
                                type['url']!,
                                width: 24,
                                height: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(type['name']!),
                              Checkbox(
                                value: selectedType == type['name'],
                                onChanged: (bool? value) {
                                  setModalState(() {
                                    selectedType =
                                        value == true ? type['name']! : '';
                                  });
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    // 階段篩選
                    const Text('選擇階段：'),
                    DropdownButton<String>(
                      isExpanded: true,
                      value: selectedStage.isNotEmpty ? selectedStage : null,
                      hint: const Text('請選擇階段'),
                      items: stages
                          .map((stage) => DropdownMenuItem<String>(
                                value: stage,
                                child: Text(stage),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setModalState(() {
                          selectedStage = value ?? '';
                        });
                        setState(() {});
                      },
                    ),

                    const SizedBox(height: 16),

                    // 弱點篩選
                    const Text('選擇弱點：'),
                    DropdownButton<String>(
                      isExpanded: true,
                      value:
                          selectedWeakness.isNotEmpty ? selectedWeakness : null,
                      hint: const Text('請選擇弱點'),
                      items: types
                          .map((type) => DropdownMenuItem<String>(
                                value: type['name']!,
                                child: Row(
                                  children: [
                                    Image.network(
                                      type['url']!,
                                      width: 24,
                                      height: 24,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(type['name']!),
                                  ],
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setModalState(() {
                          selectedWeakness = value ?? '';
                        });
                        setState(() {});
                      },
                    ),

                    const SizedBox(height: 16),

                    // 抵抗力篩選
                    const Text('選擇抵抗力：'),
                    DropdownButton<String>(
                      isExpanded: true,
                      value: selectedResistance.isNotEmpty
                          ? selectedResistance
                          : null,
                      hint: const Text('請選擇抵抗力'),
                      items: types
                          .map((type) => DropdownMenuItem<String>(
                                value: type['name']!,
                                child: Row(
                                  children: [
                                    Image.network(
                                      type['url']!,
                                      width: 24,
                                      height: 24,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(type['name']!),
                                  ],
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setModalState(() {
                          selectedResistance = value ?? '';
                        });
                        setState(() {});
                      },
                    ),

                    const SizedBox(height: 16),

                    // 測退所需能量篩選
                    const Text('退場所需能量：'),
                    DropdownButton<String>(
                      isExpanded: true,
                      value: selectedRetreatCost.isNotEmpty
                          ? selectedRetreatCost
                          : null,
                      hint: const Text('請選擇退場所需能量'),
                      items: energyCost
                          .map((cost) => DropdownMenuItem<String>(
                                value: cost,
                                child: Text('$cost 能量'),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setModalState(() {
                          selectedRetreatCost = value ?? '';
                        });
                        setState(() {});
                      },
                    ),

                    const SizedBox(height: 16),

                    // HP 範圍篩選
                    const Text('選擇 HP 範圍：'),
                    RangeSlider(
                      values: RangeValues(minHP, maxHP),
                      min: 0,
                      max: 500,
                      divisions: 50, // 分成 100 段，每段代表 10
                      labels: RangeLabels(
                        '${minHP.toInt()}',
                        '${maxHP.toInt()}',
                      ),
                      onChanged: (RangeValues values) {
                        setModalState(() {
                          minHP = values.start;
                          maxHP = values.end;
                        });
                        setState(() {});
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('最低 HP: ${minHP.toInt()}'),
                        Text('最高 HP: ${maxHP.toInt()}'),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // 完成按鈕
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // 關閉 BottomSheet
                        },
                        child: const Text('完成'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PTCG Cards'), // 應用標題
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list), // 篩選按鈕圖標
            onPressed: _onFilterPressed,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    focusNode: nameFocusNode,
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: '輸入卡片名稱',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _onSearchPressed,
                  child: const Icon(Icons.search),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16), // 添加間距
          Expanded(
            child: PTCGDATAAPI(
              deckId: widget.deckId, // 使用 widget 引用父組件的參數, // 傳遞 deckId
              name: nameController.text, // 名稱篩選
              move: '', // 預留空白欄位（如果需要支持其他條件）
              stage_filter: selectedStage, // 階段篩選
              type_filter: selectedType, // 屬性篩選
              weakness_filter: selectedWeakness, // 弱點篩選
              resistance_filter: selectedResistance, // 抵抗力篩選
              retreat_cost_filter: selectedRetreatCost, // 退場所需能量篩選
              hp_min: minHP.toInt(), // 最低 HP 篩選
              hp_max: maxHP.toInt(), // 最高 HP 篩選
            ),
          ),
        ],
      ),
    );
  }
}
