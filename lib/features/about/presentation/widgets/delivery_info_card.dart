import 'package:flutter/material.dart';
import 'package:ordering_app/core/utils/html_content_renderer.dart';
import 'package:ordering_app/features/about/domain/entities/info_entity.dart';

class DeliveryInfoCard extends StatelessWidget {
  final DeliveryInfoEntity deliveryInfo;

  const DeliveryInfoCard({
    super.key,
    required this.deliveryInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              deliveryInfo.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(
              height: 24,
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                return renderHtml(
                  html: deliveryInfo.description,
                  width: constraints.maxWidth,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
