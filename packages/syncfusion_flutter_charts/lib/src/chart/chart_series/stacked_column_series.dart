part of charts;

/// Renders the stacked column series.
///
/// In a stacked column chart, data series are stacked one on top of the other in vertical columns..
///
/// To render a stacked column chart, create an instance of StackedColumnSeries,
/// and add it to the series collection property of [SfCartesianChart].
///
///Provides options to customize properties such as [color], [opacity],
///[borderWidth], [borderColor], [borderRadius] of the Stackedcolumn segemnts.
class StackedColumnSeries<T, D> extends _StackedSeriesBase<T, D> {
  /// Creating an argument constructor of StackedColumnSeries class.
  StackedColumnSeries(
      {ValueKey<String>? key,
      ChartSeriesRendererFactory<T, D>? onCreateRenderer,
      required List<T> dataSource,
      required ChartValueMapper<T, D> xValueMapper,
      required ChartValueMapper<T, num> yValueMapper,
      ChartValueMapper<T, dynamic>? sortFieldValueMapper,
      ChartValueMapper<T, Color>? pointColorMapper,
      ChartValueMapper<T, String>? dataLabelMapper,
      SortingOrder? sortingOrder,
      bool? isTrackVisible,
      String? groupName,
      String? xAxisName,
      String? yAxisName,
      List<Trendline>? trendlines,
      String? name,
      Color? color,
      double? width,
      double? spacing,
      MarkerSettings? markerSettings,
      EmptyPointSettings? emptyPointSettings,
      DataLabelSettings? dataLabelSettings,
      bool? isVisible,
      LinearGradient? gradient,
      LinearGradient? borderGradient,
      BorderRadius? borderRadius,
      bool? enableTooltip,
      double? animationDuration,
      Color? trackColor,
      Color? trackBorderColor,
      double? trackBorderWidth,
      double? trackPadding,
      Color? borderColor,
      double? borderWidth,
      // ignore: deprecated_member_use_from_same_package
      SelectionSettings? selectionSettings,
      SelectionBehavior? selectionBehavior,
      bool? isVisibleInLegend,
      LegendIconType? legendIconType,
      String? legendItemText,
      List<double>? dashArray,
      double? opacity,
      SeriesRendererCreatedCallback? onRendererCreated,
      List<int>? initialSelectedDataIndexes})
      : super(
            key: key,
            onCreateRenderer: onCreateRenderer,
            name: name,
            dashArray: dashArray,
            groupName: groupName,
            spacing: spacing,
            xValueMapper: xValueMapper,
            yValueMapper: yValueMapper,
            sortFieldValueMapper: sortFieldValueMapper,
            pointColorMapper: pointColorMapper,
            trendlines: trendlines,
            dataLabelMapper: dataLabelMapper,
            dataSource: dataSource,
            xAxisName: xAxisName,
            isTrackVisible: isTrackVisible,
            trackColor: trackColor,
            trackBorderColor: trackBorderColor,
            trackBorderWidth: trackBorderWidth,
            trackPadding: trackPadding,
            yAxisName: yAxisName,
            color: color,
            width: width ?? 0.7,
            markerSettings: markerSettings,
            dataLabelSettings: dataLabelSettings,
            isVisible: isVisible,
            gradient: gradient,
            borderGradient: borderGradient,
            emptyPointSettings: emptyPointSettings,
            enableTooltip: enableTooltip,
            animationDuration: animationDuration,
            borderColor: borderColor,
            borderWidth: borderWidth,
            borderRadius: borderRadius,
            selectionSettings: selectionSettings,
            selectionBehavior: selectionBehavior,
            legendItemText: legendItemText,
            isVisibleInLegend: isVisibleInLegend,
            legendIconType: legendIconType,
            sortingOrder: sortingOrder,
            opacity: opacity,
            onRendererCreated: onRendererCreated,
            initialSelectedDataIndexes: initialSelectedDataIndexes);

  /// Create the stacked area series renderer.
  StackedColumnSeriesRenderer createRenderer(ChartSeries<T, D> series) {
    StackedColumnSeriesRenderer stackedAreaSeriesRenderer;
    if (onCreateRenderer != null) {
      stackedAreaSeriesRenderer =
          onCreateRenderer!(series) as StackedColumnSeriesRenderer;
      // ignore: unnecessary_null_comparison
      assert(stackedAreaSeriesRenderer != null,
          'This onCreateRenderer callback function should return value as extends from ChartSeriesRenderer class and should not be return value as null');
      return stackedAreaSeriesRenderer;
    }
    return StackedColumnSeriesRenderer();
  }
}

/// Creates series renderer for Stacked column series
class StackedColumnSeriesRenderer extends _StackedSeriesRenderer {
  /// Calling the default constructor of StackedColumnSeriesRenderer class.
  StackedColumnSeriesRenderer();
  @override
  late num _rectPosition;
  @override
  late num _rectCount;

  /// Stacked Bar segment is created here.
  // ignore: unused_element
  ChartSegment _createSegments(CartesianChartPoint<dynamic> currentPoint,
      int pointIndex, int seriesIndex, double animateFactor) {
    final StackedColumnSegment segment = createSegment();
    final StackedColumnSeries<dynamic, dynamic> _stackedColumnSeries =
        _series as StackedColumnSeries;
    _isRectSeries = true;
    // ignore: unnecessary_null_comparison
    if (segment != null) {
      segment._seriesIndex = seriesIndex;
      segment.currentSegmentIndex = pointIndex;
      segment.points.add(
          Offset(currentPoint.markerPoint!.x, currentPoint.markerPoint!.y));
      segment._seriesRenderer = this;
      segment._series = _stackedColumnSeries;
      segment._currentPoint = currentPoint;
      segment.animationFactor = animateFactor;
      segment._path = _findingRectSeriesDashedBorder(
          currentPoint, _stackedColumnSeries.borderWidth);
      segment.segmentRect = _getRRectFromRect(
          currentPoint.region!, _stackedColumnSeries.borderRadius);

      //Tracker rect
      if (_stackedColumnSeries.isTrackVisible) {
        segment._trackRect = _getRRectFromRect(
            currentPoint.trackerRectRegion!, _stackedColumnSeries.borderRadius);
        segment._trackerFillPaint = segment._getTrackerFillPaint();
        segment._trackerStrokePaint = segment._getTrackerStrokePaint();
      }
      segment._segmentRect = segment.segmentRect;
      segment._oldSegmentIndex = _getOldSegmentIndex(segment);
      customizeSegment(segment);
      segment.strokePaint = segment.getStrokePaint();
      segment.fillPaint = segment.getFillPaint();
      _segments.add(segment);
    }
    return segment;
  }

  /// To render stacked column series segments
  //ignore: unused_element
  void _drawSegment(Canvas canvas, ChartSegment segment) {
    if (segment._seriesRenderer._isSelectionEnable) {
      final SelectionBehaviorRenderer? selectionBehaviorRenderer =
          segment._seriesRenderer._selectionBehaviorRenderer;
      selectionBehaviorRenderer?._selectionRenderer?._checkWithSelectionState(
          _segments[segment.currentSegmentIndex!], _chart);
    }
    segment.onPaint(canvas);
  }

  @override
  StackedColumnSegment createSegment() => StackedColumnSegment();

  @override
  void customizeSegment(ChartSegment segment) {
    segment._color = segment._seriesRenderer._seriesColor;
    segment._strokeColor = segment._series.borderColor;
    segment._strokeWidth = segment._series.borderWidth;
  }

  @override
  void drawDataLabel(int index, Canvas canvas, String dataLabel, double pointX,
          double pointY, int angle, TextStyle style) =>
      _drawText(canvas, dataLabel, Offset(pointX, pointY), style, angle);

  @override
  void drawDataMarker(int index, Canvas canvas, Paint fillPaint,
      Paint strokePaint, double pointX, double pointY,
      [CartesianSeriesRenderer? seriesRenderer]) {
    canvas.drawPath(seriesRenderer!._markerShapes[index]!, fillPaint);
    canvas.drawPath(seriesRenderer._markerShapes[index]!, strokePaint);
  }
}
