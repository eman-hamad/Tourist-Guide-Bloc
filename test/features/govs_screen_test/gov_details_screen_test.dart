import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tourist_guide/data/dummy/dummy_data.dart';
import 'package:tourist_guide/features/Home/tabs/govs/bloc/gov_details_cubit/gov_details_cubit.dart';
import 'package:tourist_guide/features/Home/tabs/govs/ui/gov_details.dart';
import 'package:tourist_guide/features/Home/tabs/govs/widgets/details_list.dart';

class MockGovDetailsCubit extends MockCubit<GovDetailsState>
    implements GovDetailsCubit {}

@override
Future<void> getDetails(String govName) => Future.value();

void main() {
  late MockGovDetailsCubit mockCubit;

  setUp(() {
    mockCubit = MockGovDetailsCubit();
  });

  Widget makeTestableWidget(Widget child, {required String govName}) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      child: MaterialApp(
        onGenerateRoute: (settings) => MaterialPageRoute(
          settings: RouteSettings(arguments: govName),
          builder: (context) => BlocProvider<GovDetailsCubit>.value(
            value: mockCubit,
            child: child,
          ),
        ),
      ),
    );
  }

  testWidgets('displays loading state', (WidgetTester tester) async {
    when(() => mockCubit.state).thenReturn(GovDetailsLoading());

    when(() => mockCubit.getDetails(any())).thenAnswer((_) async {});

    await tester.pumpWidget(
      makeTestableWidget(const GovernorateDetails(), govName: 'Cairo'),
    );

    expect(find.byType(DetailsList), findsOneWidget);
  });

  testWidgets('displays loaded state with data', (WidgetTester tester) async {
    final testGovs = [kDummyData];
    when(() => mockCubit.state).thenReturn(GovDetailsLoaded(govs: testGovs));
    when(() => mockCubit.getDetails(any())).thenAnswer((_) async {});

    await tester.pumpWidget(
      makeTestableWidget(const GovernorateDetails(), govName: 'Cairo'),
    );

    expect(find.byType(DetailsList), findsOneWidget);
  });

  testWidgets('displays error message when error state occurs',
      (WidgetTester tester) async {
    const errorMsg = 'Failed to load landmarks';
    when(() => mockCubit.state).thenReturn(GovDetailsError(errorMsg: errorMsg));
    when(() => mockCubit.getDetails(any())).thenAnswer((_) async {});

    await tester.pumpWidget(
      makeTestableWidget(const GovernorateDetails(), govName: 'Cairo'),
    );

    expect(find.text(errorMsg), findsOneWidget);
  });
}
