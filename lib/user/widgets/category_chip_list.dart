import 'package:buddy/constants.dart';
import 'package:flutter/material.dart';

class CategoryChipList extends StatefulWidget {
  final List<dynamic> categoryChipList;

  const CategoryChipList({required this.categoryChipList});

  @override
  _CategoryChipListState createState() => _CategoryChipListState();
}

class _CategoryChipListState extends State<CategoryChipList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.categoryChipList!.length,
          itemBuilder: (context, index) {
            return Row(
              children: [
                InkWell(
                  onTap: () {},
                  child: Chip(
                    labelPadding: EdgeInsets.all(2.0),
                    label: Text(
                      widget.categoryChipList![index],
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
            );
          },
        ),
      ],
    );
  }
}
