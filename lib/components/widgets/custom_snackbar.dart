
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomSuccessSnackBar extends StatelessWidget {
  const CustomSuccessSnackBar({super.key, required this.errorText});
  final String errorText;
  @override
  Widget build(BuildContext context) {
    return SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        duration: const Duration(seconds: 2),
        content: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              height: 90,
              decoration: BoxDecoration(
                  color: Colors.deepPurple.shade400,
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
              child:  Row(
                children: [
                  const SizedBox(
                    width: 48,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Congrats!',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                         const Spacer(),
                        Text(
                          errorText,
                          style:const TextStyle(fontSize: 12, color: Colors.white),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.only(bottomLeft: Radius.circular(20)),
                child: SvgPicture.asset(
                  'assets/icons.bubbles.svg',
                  height: 48,
                  width: 40,
                  // ignore: deprecated_member_use
                  color: Colors.deepPurple.shade600,
                ),
              ),
            ),
            Positioned(
              top: -20,
              bottom: 0,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset('assets/icons/fail.svg', height: 40,),
                  Positioned(
                    top: 10,
                    child: SvgPicture.asset('assets/icons/close.svg', height: 16,))
                ],
               )),
          ],
        ));
  }
}
