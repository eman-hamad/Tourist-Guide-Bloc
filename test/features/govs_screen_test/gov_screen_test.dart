import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tourist_guide/features/Home/tabs/govs/bloc/gov_scrren_cubit/gov_screen_cubit.dart';
import 'package:tourist_guide/features/Home/tabs/govs/ui/govs_screen.dart';
import 'package:tourist_guide/features/Home/tabs/govs/widgets/govs_grid.dart';

class MockGovScreenCubit extends MockCubit<GovScreenState>
    implements GovScreenCubit {}

void main() {
  late MockGovScreenCubit mockCubit;

  setUp(() {
    mockCubit = MockGovScreenCubit();
  });

  Widget makeTestableWidget(Widget child) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        home: BlocProvider<GovScreenCubit>.value(
          value: mockCubit,
          child: child,
        ),
      ),
    );
  }

  testWidgets('displays loading state', (WidgetTester tester) async {
    when(() => mockCubit.state).thenReturn(GovScreenLoading());

    await tester.pumpWidget(makeTestableWidget(const GovernorateScreen()));
    expect(find.byType(GovsGrid), findsOneWidget);
  });

  testWidgets('displays loaded state with data', (WidgetTester tester) async {
    final testGovs = [GovernorateScreen.dummyData];
    when(() => mockCubit.state).thenReturn(GovScreenLoaded(govs: testGovs));

    await tester.pumpWidget(makeTestableWidget(const GovernorateScreen()));
    expect(find.byType(GovsGrid), findsOneWidget);
  });

  testWidgets('displays error message when error state occurs',
      (WidgetTester tester) async {
    const errorMsg = 'Failed to load governorates';
    when(() => mockCubit.state).thenReturn(GovScreenError(errorMsg: errorMsg));

    await tester.pumpWidget(makeTestableWidget(const GovernorateScreen()));
    expect(find.text(errorMsg), findsOneWidget);
  });
}
