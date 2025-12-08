import 'package:flutter/material.dart';
import 'package:owlby_serene_m_i_n_d_s/bottom_nav.dart/bottom_button.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: const BoxDecoration(
        color: Color(0xFF2596BE),
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            offset: Offset(0, -2),
            color: Colors.black12,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          bottombuttons.length,
          (i) {
            final item = bottombuttons[i];
            final isActive = i == currentIndex;

            return Expanded(
              child: InkWell(
                onTap: () => onTap(i),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isActive ? item.selected : item.unselected,
                      color: isActive
                          ? Colors.white
                          : Color.fromARGB(255, 4, 70, 94),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            isActive ? FontWeight.w600 : FontWeight.normal,
                        color: isActive
                            ? Colors.white
                            : Color.fromARGB(255, 4, 70, 94),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
