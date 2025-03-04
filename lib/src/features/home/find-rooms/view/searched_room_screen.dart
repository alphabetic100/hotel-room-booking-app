import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_booking_app/src/core/constants/utils/colors/colors.dart';
import 'package:hotel_booking_app/src/core/constants/utils/screen_size.dart';
import 'package:hotel_booking_app/src/core/constants/utils/styles/custom_text_style.dart';
import 'package:hotel_booking_app/src/core/custom/common/widgets/custom_app_bar.dart';
import 'package:hotel_booking_app/src/core/custom/common/widgets/custom_button.dart';
import 'package:hotel_booking_app/src/core/custom/common/widgets/custom_spacing.dart';
import 'package:hotel_booking_app/src/core/custom/custom_tile_widget.dart';
import 'package:hotel_booking_app/src/features/home/components/date-picker/controller/date_picker_controller.dart';
import 'package:hotel_booking_app/src/features/home/controller/guest_and_room_controller.dart';
import 'package:hotel_booking_app/src/features/home/find-rooms/components/search_details.dart';
import 'package:hotel_booking_app/src/features/home/find-rooms/components/sort-bottom-sheet/view/sort_bottom_sheet.dart';
import 'package:hotel_booking_app/src/features/home/find-rooms/controller/search_loading_controller.dart';
import 'package:hotel_booking_app/src/features/home/find-rooms/service/model/search_data.dart';
import 'package:hotel_booking_app/src/features/home/find-rooms/service/search_service.dart';

class SearchedRoomScreen extends StatefulWidget {
  const SearchedRoomScreen(
      {super.key, required this.checkIn, required this.checkOut});
  final String checkIn;
  final String checkOut;

  @override
  State<SearchedRoomScreen> createState() => _SearchedRoomScreenState();
}

class _SearchedRoomScreenState extends State<SearchedRoomScreen> {
  final DatePickerController controller = Get.put(DatePickerController());
  final SearchLoadingController loadingController =
      Get.put(SearchLoadingController());
  final SearchService service = SearchService();
  SearchData? data;
  Future fetchSearchData() async {
    data = await service.getSearchRoom(widget.checkIn, widget.checkOut);
  }

  @override
  void initState() {
    fetchSearchData();
    super.initState();
  }

  final GuestAndRoomController guestAndRoomController =
      Get.put(GuestAndRoomController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.scaffoldBackgroundColor,
      appBar: const CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Obx(
          () {
            if (loadingController.isLoading.value) {
              return Center(
                child: CircularProgressIndicator(
                  color: ColorTheme.blue,
                ),
              );
            }
            if (data == null) {
              return Center(
                child: CircularProgressIndicator(
                  color: ColorTheme.blue,
                ),
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "The Grand Haven",
                    style: CustomStyle.blueTitleText,
                  ),
                  const VerticalSpace(height: 15),
                  Row(
                    children: [
                      CustomTileWidget(
                          child: Row(
                        children: [
                          Icon(
                            Icons.calendar_month_outlined,
                            color: ColorTheme.grey,
                          ),
                          const HorizontalSpace(width: 5),
                          Text(
                            "${controller.checkInDate.value} - ${controller.checkOutDate.value}",
                            style: CustomStyle.blueTextStyle,
                          )
                        ],
                      )),
                      const HorizontalSpace(width: 15),
                      CustomTileWidget(
                          child: Text(
                        "${guestAndRoomController.guests.value} Guests",
                        style: CustomStyle.blueTextStyle,
                      ))
                    ],
                  ),
                  const VerticalSpace(height: 10),
                  Expanded(
                    child: SizedBox(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Recommended Hotels",
                              style: CustomStyle.blueTitleText,
                            ),
                            //search details here
                            SizedBox(
                                height: ScreenSize.height * 0.4,
                                child: SearchDetails(
                                  data: data!,
                                )),
                            Text(
                              "Business Accommodates",
                              style: CustomStyle.blueTitleText,
                            ),
                            SizedBox(
                                height: ScreenSize.height * 0.4,
                                child: SearchDetails(
                                  data: data!,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: CustomButton(
                      onTap: () {
                        Get.bottomSheet(SortBottomSheet());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.sort,
                            size: 25,
                            color: ColorTheme.white,
                          ),
                          Text(
                            "filter search",
                            style: CustomStyle.buttonTextStyl,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
