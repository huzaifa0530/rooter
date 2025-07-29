import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rooster/Controllers/HandbookController.dart';
import 'package:rooster/HandbookDetailScreen.dart';

import 'package:rooster/widgets/custom_bottom_nav.dart';

class HandbookListScreen extends StatelessWidget {
	const HandbookListScreen({super.key});

	@override
	Widget build(BuildContext context) {
		final controller = Get.put(HandbookController());
		final theme = Theme.of(context);

		return Scaffold(
			backgroundColor: theme.scaffoldBackgroundColor,
			appBar: AppBar(
				title: Row(
					children: [
						// const Icon(Icons.restaurant_menu, size: 24),
						// const SizedBox(width: 2),
						Text('chef_handbook'.tr),
					],
				),
				actions: [
					Obx(() => IconButton(
						tooltip: controller.isGrid.value
							? 'Switch to List View'
							: 'Switch to Grid View',
						icon: Icon(controller.isGrid.value
							? Icons.view_list
							: Icons.grid_view),
						onPressed: controller.toggleLayout,
						)),
				],
			),
			body: Obx(() {
				if (controller.loading.value) {
					return const Center(child: CircularProgressIndicator());
				}

				if (controller.handbooks.isEmpty) {
					return Center(
						child: Text(
							'no_handbooks'.tr,
							textAlign: TextAlign.center,
							style: const TextStyle(fontSize: 16, color: Colors.black54),
						),
					);
				}

				return Padding(
					padding: const EdgeInsets.all(16.0),
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							Text(
								'handbook_description'.tr,
								style: const TextStyle(fontSize: 14, color: Colors.black87),
							),
							const SizedBox(height: 16),
							Expanded(
								child: controller.isGrid.value
									? GridView.builder(
										itemCount: controller.handbooks.length,
										gridDelegate:
											const SliverGridDelegateWithFixedCrossAxisCount(
											crossAxisCount: 2,
											crossAxisSpacing: 16,
											mainAxisSpacing: 16,
											childAspectRatio: 0.55,

										),
										itemBuilder: (_, index) {
											final handbook = controller.handbooks[index];
											return 

											SizedBox(
												height: 2800,
												child: Material(
													color: theme.cardColor,
													borderRadius: BorderRadius.circular(16),
													elevation: 6,
													shadowColor: Colors.black12,
													child: InkWell(
														onTap: () async {
	final detail = await controller.fetchHandbookDetail(handbook.id);
	if (detail != null) {
		Get.to(() => HandbookDetailScreen(handbook: detail));
	}
},
	borderRadius: BorderRadius.circular(16),
	child: Column(
		crossAxisAlignment: CrossAxisAlignment.start,
		children: [
			ClipRRect(
				borderRadius: const BorderRadius.vertical(
					top: Radius.circular(16)),
				child: SizedBox(
					height: 140,
					width: double.infinity,
					child: handbook.thumbnailUrl
						.startsWith('http')
						? Image.network(
							handbook.thumbnailUrl,
							fit: BoxFit.cover,
							errorBuilder: (_, __, ___) =>
								Container(
								color: Colors.grey[100],
								child: const Center(
									child: Icon(Icons.menu_book,
										size: 50,
										color: Colors.black45),
								),
							),
							)
						: Image.asset(
							handbook.thumbnailUrl,
							fit: BoxFit.cover,
							),
				),
			),
			Expanded(
				child: Padding(
					padding: const EdgeInsets.all(12),
					child: Column(
						crossAxisAlignment:
							CrossAxisAlignment.start,
						children: [
							Text(
								handbook.title,
								style: theme.textTheme.titleMedium
									?.copyWith(
										fontWeight:
											FontWeight.w700),
								maxLines: 2,
								overflow: TextOverflow.ellipsis,
							),
							const SizedBox(height: 6),
							Expanded(
								child: Text(
									handbook.description,
									maxLines: 3,
									overflow: TextOverflow.ellipsis,
									style: theme.textTheme.bodySmall
										?.copyWith(
											color: Colors.grey[600]),
								),
							),
						],
					),
				),
			),
		],
	),
	),
	),
	);


	},
	)
	: ListView.separated(
		itemCount: controller.handbooks.length,
		separatorBuilder: (_, __) => const SizedBox(height: 12),
		itemBuilder: (_, index) {
			final handbook = controller.handbooks[index];
			return Card(
				elevation: 3,
				shape: RoundedRectangleBorder(
					borderRadius: BorderRadius.circular(12)),
				child: ListTile(
					contentPadding: const EdgeInsets.all(12),
					leading:
						ClipRRect(
							borderRadius: BorderRadius.circular(8),
							child: SizedBox(
								width: 56,
								height: 56,
								child: handbook.thumbnailUrl
									.startsWith('http')
									? Image.network(
										handbook.thumbnailUrl,
										fit: BoxFit.cover,
										errorBuilder: (_, __, ___) =>
											Container(
											color: Colors.grey[100],
											child: const Icon(Icons.menu_book,
												size: 32,
												color: Colors.black45),
										),
										)
									: Image.asset(
										handbook.thumbnailUrl,
										fit: BoxFit.cover,
										),
							),
					),
					title: Text(
						handbook.title,
						style: const TextStyle(
							fontWeight: FontWeight.bold),
					),
					subtitle: Text(
						handbook.description,
						maxLines: 2,
						overflow: TextOverflow.ellipsis,
						style: const TextStyle(
							fontSize: 13, color: Colors.black54),
					),
					trailing: const Icon(Icons.chevron_right),
					onTap: () => Get.to(() =>
						HandbookDetailScreen(handbook: handbook)),
				),
			);
		},
		),
	),
	],
	),
	);
	}), bottomNavigationBar: const CustomBottomNavBar(currentIndex: 3),
	);
	}
}
