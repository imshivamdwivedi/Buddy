import 'package:buddy/constants.dart';
import 'package:buddy/user/widgets/category_chip_list.dart';
import 'package:flutter/material.dart';

class CatogoryChips extends StatefulWidget {
  final List<dynamic>? categories;
  const CatogoryChips({required this.categories});

  @override
  _CatogoryChipsState createState() => _CatogoryChipsState();
}

class _CatogoryChipsState extends State<CatogoryChips> {
  void rowList() {
    var i;
    int noOfRows = widget.categories!.length / 4 as int;
    for (i = 0; i < noOfRows; i++) {
      CategoryChipList(
          categoryChipList: widget.categories!.sublist(i * 4, (i + 1) * 4));
    }
    CategoryChipList(
      categoryChipList:
          widget.categories!.sublist((i + 1) * 4, widget.categories!.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      width: double.infinity,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.categories!.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Chip(
                        labelPadding: EdgeInsets.all(2.0),
                        label: Text(
                          widget.categories![index],
                          style: TextStyle(
                            color: Colors.black87,
                          ),
                        ),
                        backgroundColor: kPrimaryLightColor,
                        elevation: 6.0,
                        shadowColor: Colors.grey[60],
                        padding: EdgeInsets.all(8.0),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    )
                  ],
                ),
              ],
            );
          }),
    );
  }
}
