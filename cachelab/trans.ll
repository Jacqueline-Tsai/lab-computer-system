; ModuleID = 'trans.c'
source_filename = "trans.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [21 x i8] c"Transpose submission\00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"Basic\00", align 1

; Function Attrs: nounwind uwtable
define dso_local void @registerFunctions() local_unnamed_addr #0 !dbg !9 {
  tail call void @registerTransFunction(void (i64, i64, double*, double*, double*)* noundef nonnull @transpose_submit, i8* noundef getelementptr inbounds ([21 x i8], [21 x i8]* @.str, i64 0, i64 0)) #4, !dbg !13
  tail call void @registerTransFunction(void (i64, i64, double*, double*, double*)* noundef nonnull @trans_basic, i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.1, i64 0, i64 0)) #4, !dbg !14
  ret void, !dbg !15
}

declare !dbg !16 void @registerTransFunction(void (i64, i64, double*, double*, double*)* noundef, i8* noundef) local_unnamed_addr #1

; Function Attrs: nofree norecurse nosync nounwind uwtable
define internal void @transpose_submit(i64 noundef %0, i64 noundef %1, double* nocapture noundef readonly %2, double* nocapture noundef writeonly %3, double* nocapture noundef %4) #2 !dbg !35 {
  call void @llvm.dbg.value(metadata i64 %0, metadata !37, metadata !DIExpression()), !dbg !48
  call void @llvm.dbg.value(metadata i64 %1, metadata !38, metadata !DIExpression()), !dbg !48
  call void @llvm.dbg.value(metadata double* %2, metadata !39, metadata !DIExpression()), !dbg !48
  call void @llvm.dbg.value(metadata double* %3, metadata !40, metadata !DIExpression()), !dbg !48
  call void @llvm.dbg.value(metadata double* %4, metadata !41, metadata !DIExpression()), !dbg !48
  %6 = icmp eq i64 %0, %1, !dbg !49
  %7 = and i64 %0, 7
  %8 = icmp eq i64 %7, 0
  %9 = and i1 %6, %8, !dbg !51
  br i1 %9, label %10, label %101, !dbg !51

10:                                               ; preds = %5
  %11 = and i64 %0, -8
  call void @llvm.dbg.value(metadata i64 0, metadata !42, metadata !DIExpression()), !dbg !52
  %12 = icmp eq i64 %11, 0, !dbg !53
  br i1 %12, label %151, label %13, !dbg !54

13:                                               ; preds = %10, %98
  %14 = phi i64 [ %99, %98 ], [ 0, %10 ]
  %15 = phi i64 [ %17, %98 ], [ 0, %10 ]
  call void @llvm.dbg.value(metadata i64 %15, metadata !42, metadata !DIExpression()), !dbg !52
  call void @llvm.dbg.value(metadata i64 undef, metadata !44, metadata !DIExpression()), !dbg !55
  %16 = or i64 %15, 7
  %17 = add nuw i64 %15, 8
  %18 = mul nsw i64 %15, %0
  %19 = getelementptr inbounds double, double* %3, i64 %18
  %20 = or i64 %15, 1
  %21 = getelementptr inbounds double, double* %2, i64 %18
  %22 = getelementptr inbounds double, double* %3, i64 %15
  %23 = getelementptr inbounds double, double* %2, i64 %18
  %24 = getelementptr inbounds double, double* %23, i64 %15
  %25 = getelementptr inbounds double, double* %19, i64 %15
  br label %26, !dbg !56

26:                                               ; preds = %13, %93
  %27 = phi i64 [ 0, %13 ], [ %94, %93 ]
  %28 = icmp eq i64 %15, %27, !dbg !57
  br i1 %28, label %45, label %96, !dbg !61

29:                                               ; preds = %96, %42
  %30 = phi i64 [ %43, %42 ], [ %27, %96 ]
  call void @llvm.dbg.value(metadata i64 %30, metadata !62, metadata !DIExpression()), !dbg !81
  call void @llvm.dbg.value(metadata i64 %15, metadata !77, metadata !DIExpression()), !dbg !84
  %31 = mul nsw i64 %30, %0
  %32 = getelementptr inbounds double, double* %2, i64 %31
  %33 = getelementptr inbounds double, double* %3, i64 %30
  br label %34, !dbg !85

34:                                               ; preds = %34, %29
  %35 = phi i64 [ %15, %29 ], [ %40, %34 ]
  call void @llvm.dbg.value(metadata i64 %35, metadata !77, metadata !DIExpression()), !dbg !84
  %36 = getelementptr inbounds double, double* %32, i64 %35, !dbg !86
  %37 = load double, double* %36, align 8, !dbg !86, !tbaa !89
  %38 = mul nsw i64 %35, %0, !dbg !93
  %39 = getelementptr inbounds double, double* %33, i64 %38, !dbg !93
  store double %37, double* %39, align 8, !dbg !94, !tbaa !89
  %40 = add nuw i64 %35, 1, !dbg !95
  call void @llvm.dbg.value(metadata i64 %40, metadata !77, metadata !DIExpression()), !dbg !84
  %41 = icmp eq i64 %35, %16, !dbg !96
  br i1 %41, label %42, label %34, !dbg !85, !llvm.loop !97

42:                                               ; preds = %34
  %43 = add nuw i64 %30, 1, !dbg !100
  call void @llvm.dbg.value(metadata i64 %43, metadata !62, metadata !DIExpression()), !dbg !81
  %44 = icmp eq i64 %30, %97, !dbg !101
  br i1 %44, label %93, label %29, !dbg !102, !llvm.loop !103

45:                                               ; preds = %26, %61
  %46 = phi i64 [ %62, %61 ], [ %20, %26 ]
  call void @llvm.dbg.value(metadata i64 %46, metadata !105, metadata !DIExpression()), !dbg !132
  %47 = shl i64 %46, 5, !dbg !135
  call void @llvm.dbg.value(metadata !DIArgList(i64 undef, i64 %46), metadata !118, metadata !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_constu, 3, DW_OP_shr, DW_OP_LLVM_arg, 1, DW_OP_constu, 5, DW_OP_shl, DW_OP_plus, DW_OP_plus_uconst, 1, DW_OP_constu, 31, DW_OP_and, DW_OP_stack_value)), !dbg !136
  call void @llvm.dbg.value(metadata i64 %15, metadata !121, metadata !DIExpression()), !dbg !137
  %48 = mul nsw i64 %46, %0
  %49 = getelementptr inbounds double, double* %2, i64 %48
  %50 = add i64 %47, %17
  %51 = and i64 %50, 248
  %52 = add i64 %51, %14
  br label %53, !dbg !138

53:                                               ; preds = %53, %45
  %54 = phi i64 [ %15, %45 ], [ %59, %53 ]
  call void @llvm.dbg.value(metadata i64 %54, metadata !121, metadata !DIExpression()), !dbg !137
  %55 = getelementptr inbounds double, double* %49, i64 %54, !dbg !139
  %56 = load double, double* %55, align 8, !dbg !139, !tbaa !89
  %57 = add i64 %52, %54, !dbg !142
  %58 = getelementptr inbounds double, double* %4, i64 %57, !dbg !143
  store double %56, double* %58, align 8, !dbg !144, !tbaa !89
  %59 = add nuw i64 %54, 1, !dbg !145
  call void @llvm.dbg.value(metadata i64 %59, metadata !121, metadata !DIExpression()), !dbg !137
  %60 = icmp eq i64 %59, %17, !dbg !146
  br i1 %60, label %61, label %53, !dbg !138, !llvm.loop !147

61:                                               ; preds = %53
  %62 = add nuw i64 %46, 1, !dbg !149
  call void @llvm.dbg.value(metadata i64 %62, metadata !105, metadata !DIExpression()), !dbg !132
  %63 = icmp eq i64 %62, %17, !dbg !150
  br i1 %63, label %64, label %45, !dbg !151, !llvm.loop !152

64:                                               ; preds = %61, %64
  %65 = phi i64 [ %70, %64 ], [ %16, %61 ]
  %66 = getelementptr inbounds double, double* %21, i64 %65, !dbg !154
  %67 = load double, double* %66, align 8, !dbg !154, !tbaa !89
  %68 = mul nsw i64 %65, %0, !dbg !157
  %69 = getelementptr inbounds double, double* %22, i64 %68, !dbg !157
  store double %67, double* %69, align 8, !dbg !158, !tbaa !89
  call void @llvm.dbg.value(metadata i64 %65, metadata !123, metadata !DIExpression(DW_OP_constu, 1, DW_OP_minus, DW_OP_stack_value)), !dbg !159
  %70 = add nsw i64 %65, -1, !dbg !159
  call void @llvm.dbg.value(metadata i64 %70, metadata !123, metadata !DIExpression()), !dbg !159
  %71 = icmp ugt i64 %70, %15, !dbg !160
  br i1 %71, label %64, label %72, !dbg !161, !llvm.loop !162

72:                                               ; preds = %64
  %73 = load double, double* %24, align 8, !dbg !164, !tbaa !89
  store double %73, double* %25, align 8, !dbg !165, !tbaa !89
  call void @llvm.dbg.value(metadata i64 %20, metadata !125, metadata !DIExpression()), !dbg !166
  br label %74, !dbg !167

74:                                               ; preds = %72, %90
  %75 = phi i64 [ %91, %90 ], [ %20, %72 ]
  call void @llvm.dbg.value(metadata i64 %75, metadata !125, metadata !DIExpression()), !dbg !166
  %76 = shl i64 %75, 5, !dbg !168
  call void @llvm.dbg.value(metadata !DIArgList(i64 undef, i64 %75), metadata !127, metadata !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_constu, 3, DW_OP_shr, DW_OP_LLVM_arg, 1, DW_OP_constu, 5, DW_OP_shl, DW_OP_plus, DW_OP_plus_uconst, 1, DW_OP_constu, 31, DW_OP_and, DW_OP_stack_value)), !dbg !169
  call void @llvm.dbg.value(metadata i64 %15, metadata !130, metadata !DIExpression()), !dbg !170
  %77 = add i64 %76, %17
  %78 = and i64 %77, 248
  %79 = add i64 %78, %14
  %80 = getelementptr inbounds double, double* %3, i64 %75
  br label %81, !dbg !171

81:                                               ; preds = %81, %74
  %82 = phi i64 [ %15, %74 ], [ %88, %81 ]
  call void @llvm.dbg.value(metadata i64 %82, metadata !130, metadata !DIExpression()), !dbg !170
  %83 = add i64 %79, %82, !dbg !172
  %84 = getelementptr inbounds double, double* %4, i64 %83, !dbg !175
  %85 = load double, double* %84, align 8, !dbg !175, !tbaa !89
  %86 = mul nsw i64 %82, %0, !dbg !176
  %87 = getelementptr inbounds double, double* %80, i64 %86, !dbg !176
  store double %85, double* %87, align 8, !dbg !177, !tbaa !89
  %88 = add nuw i64 %82, 1, !dbg !178
  call void @llvm.dbg.value(metadata i64 %88, metadata !130, metadata !DIExpression()), !dbg !170
  %89 = icmp eq i64 %88, %17, !dbg !179
  br i1 %89, label %90, label %81, !dbg !171, !llvm.loop !180

90:                                               ; preds = %81
  %91 = add nuw i64 %75, 1, !dbg !182
  call void @llvm.dbg.value(metadata i64 %91, metadata !125, metadata !DIExpression()), !dbg !166
  %92 = icmp eq i64 %91, %17, !dbg !183
  br i1 %92, label %93, label %74, !dbg !167, !llvm.loop !184

93:                                               ; preds = %42, %90
  %94 = add nuw i64 %27, 8, !dbg !186
  call void @llvm.dbg.value(metadata i64 undef, metadata !44, metadata !DIExpression()), !dbg !55
  %95 = icmp ult i64 %94, %11, !dbg !187
  br i1 %95, label %26, label %98, !dbg !56, !llvm.loop !188

96:                                               ; preds = %26
  call void @llvm.dbg.value(metadata i64 %0, metadata !68, metadata !DIExpression()), !dbg !190
  call void @llvm.dbg.value(metadata i64 %1, metadata !69, metadata !DIExpression()), !dbg !190
  call void @llvm.dbg.value(metadata double* %2, metadata !70, metadata !DIExpression()), !dbg !190
  call void @llvm.dbg.value(metadata double* %3, metadata !71, metadata !DIExpression()), !dbg !190
  call void @llvm.dbg.value(metadata double* undef, metadata !72, metadata !DIExpression()), !dbg !190
  call void @llvm.dbg.value(metadata i64 %15, metadata !73, metadata !DIExpression()), !dbg !190
  call void @llvm.dbg.value(metadata i64 undef, metadata !74, metadata !DIExpression()), !dbg !190
  call void @llvm.dbg.value(metadata i64 %15, metadata !75, metadata !DIExpression(DW_OP_plus_uconst, 8, DW_OP_stack_value)), !dbg !190
  call void @llvm.dbg.value(metadata i64 undef, metadata !76, metadata !DIExpression(DW_OP_plus_uconst, 8, DW_OP_stack_value)), !dbg !190
  call void @llvm.dbg.value(metadata i64 undef, metadata !62, metadata !DIExpression()), !dbg !81
  %97 = or i64 %27, 7
  br label %29, !dbg !102

98:                                               ; preds = %93
  call void @llvm.dbg.value(metadata i64 %17, metadata !42, metadata !DIExpression()), !dbg !52
  %99 = sub nuw nsw i64 -8, %15
  %100 = icmp ult i64 %17, %11, !dbg !53
  br i1 %100, label %13, label %151, !dbg !54, !llvm.loop !191

101:                                              ; preds = %5
  call void @llvm.dbg.value(metadata i64 %0, metadata !193, metadata !DIExpression()), !dbg !206
  call void @llvm.dbg.value(metadata i64 %1, metadata !196, metadata !DIExpression()), !dbg !206
  call void @llvm.dbg.value(metadata double* %2, metadata !197, metadata !DIExpression()), !dbg !206
  call void @llvm.dbg.value(metadata double* %3, metadata !198, metadata !DIExpression()), !dbg !206
  call void @llvm.dbg.value(metadata double* %4, metadata !199, metadata !DIExpression()), !dbg !206
  call void @llvm.dbg.value(metadata i64 0, metadata !200, metadata !DIExpression()), !dbg !209
  %102 = icmp eq i64 %1, 0, !dbg !210
  %103 = icmp eq i64 %0, 0
  %104 = or i1 %103, %102, !dbg !211
  br i1 %104, label %151, label %105, !dbg !211

105:                                              ; preds = %101
  %106 = icmp ugt i64 %0, 1
  %107 = icmp eq i64 %1, 1
  %108 = and i1 %106, %107
  %109 = and i64 %0, -2
  %110 = icmp eq i64 %109, %0
  br label %111, !dbg !211

111:                                              ; preds = %105, %148
  %112 = phi i64 [ %149, %148 ], [ 0, %105 ]
  call void @llvm.dbg.value(metadata i64 %112, metadata !200, metadata !DIExpression()), !dbg !209
  call void @llvm.dbg.value(metadata i64 0, metadata !202, metadata !DIExpression()), !dbg !212
  %113 = mul i64 %112, %0
  %114 = mul nsw i64 %112, %0
  %115 = getelementptr inbounds double, double* %2, i64 %114
  %116 = getelementptr inbounds double, double* %3, i64 %112
  br i1 %108, label %117, label %138, !dbg !213

117:                                              ; preds = %111
  %118 = add i64 %113, %0
  %119 = getelementptr double, double* %2, i64 %118
  %120 = getelementptr double, double* %2, i64 %113
  %121 = add i64 %112, %0
  %122 = getelementptr double, double* %3, i64 %121
  %123 = getelementptr double, double* %3, i64 %112
  %124 = icmp ult double* %123, %119, !dbg !213
  %125 = icmp ult double* %120, %122, !dbg !213
  %126 = and i1 %124, %125, !dbg !213
  br i1 %126, label %138, label %127

127:                                              ; preds = %117, %127
  %128 = phi i64 [ %135, %127 ], [ 0, %117 ], !dbg !214
  %129 = getelementptr inbounds double, double* %115, i64 %128, !dbg !214
  %130 = bitcast double* %129 to <2 x double>*, !dbg !216
  %131 = load <2 x double>, <2 x double>* %130, align 8, !dbg !216, !tbaa !89, !alias.scope !218
  %132 = mul nsw i64 %128, %1, !dbg !214
  %133 = getelementptr inbounds double, double* %116, i64 %132, !dbg !214
  %134 = bitcast double* %133 to <2 x double>*, !dbg !221
  store <2 x double> %131, <2 x double>* %134, align 8, !dbg !221, !tbaa !89, !alias.scope !222, !noalias !218
  %135 = add nuw i64 %128, 2, !dbg !214
  %136 = icmp eq i64 %135, %109, !dbg !214
  br i1 %136, label %137, label %127, !dbg !214, !llvm.loop !224

137:                                              ; preds = %127
  br i1 %110, label %148, label %138, !dbg !213

138:                                              ; preds = %117, %111, %137
  %139 = phi i64 [ 0, %117 ], [ 0, %111 ], [ %109, %137 ]
  br label %140, !dbg !213

140:                                              ; preds = %138, %140
  %141 = phi i64 [ %146, %140 ], [ %139, %138 ]
  call void @llvm.dbg.value(metadata i64 %141, metadata !202, metadata !DIExpression()), !dbg !212
  %142 = getelementptr inbounds double, double* %115, i64 %141, !dbg !216
  %143 = load double, double* %142, align 8, !dbg !216, !tbaa !89
  %144 = mul nsw i64 %141, %1, !dbg !227
  %145 = getelementptr inbounds double, double* %116, i64 %144, !dbg !227
  store double %143, double* %145, align 8, !dbg !221, !tbaa !89
  %146 = add nuw i64 %141, 1, !dbg !214
  call void @llvm.dbg.value(metadata i64 %146, metadata !202, metadata !DIExpression()), !dbg !212
  %147 = icmp eq i64 %146, %0, !dbg !228
  br i1 %147, label %148, label %140, !dbg !213, !llvm.loop !229

148:                                              ; preds = %140, %137
  %149 = add nuw i64 %112, 1, !dbg !230
  call void @llvm.dbg.value(metadata i64 %149, metadata !200, metadata !DIExpression()), !dbg !209
  %150 = icmp eq i64 %149, %1, !dbg !210
  br i1 %150, label %151, label %111, !dbg !211, !llvm.loop !231

151:                                              ; preds = %148, %98, %10, %101
  ret void, !dbg !233
}

; Function Attrs: nofree norecurse nosync nounwind uwtable
define internal void @trans_basic(i64 noundef %0, i64 noundef %1, double* nocapture noundef readonly %2, double* nocapture noundef writeonly %3, double* nocapture noundef readnone %4) #2 !dbg !194 {
  call void @llvm.dbg.value(metadata i64 %0, metadata !193, metadata !DIExpression()), !dbg !234
  call void @llvm.dbg.value(metadata i64 %1, metadata !196, metadata !DIExpression()), !dbg !234
  call void @llvm.dbg.value(metadata double* %2, metadata !197, metadata !DIExpression()), !dbg !234
  call void @llvm.dbg.value(metadata double* %3, metadata !198, metadata !DIExpression()), !dbg !234
  call void @llvm.dbg.value(metadata double* %4, metadata !199, metadata !DIExpression()), !dbg !234
  call void @llvm.dbg.value(metadata i64 0, metadata !200, metadata !DIExpression()), !dbg !235
  %6 = icmp eq i64 %1, 0, !dbg !236
  %7 = icmp eq i64 %0, 0
  %8 = or i1 %6, %7, !dbg !237
  br i1 %8, label %55, label %9, !dbg !237

9:                                                ; preds = %5
  %10 = icmp ugt i64 %0, 1
  %11 = icmp eq i64 %1, 1
  %12 = and i1 %10, %11
  %13 = and i64 %0, -2
  %14 = icmp eq i64 %13, %0
  br label %15, !dbg !237

15:                                               ; preds = %9, %52
  %16 = phi i64 [ %53, %52 ], [ 0, %9 ]
  call void @llvm.dbg.value(metadata i64 %16, metadata !200, metadata !DIExpression()), !dbg !235
  call void @llvm.dbg.value(metadata i64 0, metadata !202, metadata !DIExpression()), !dbg !238
  %17 = mul i64 %16, %0
  %18 = mul nsw i64 %16, %0
  %19 = getelementptr inbounds double, double* %2, i64 %18
  %20 = getelementptr inbounds double, double* %3, i64 %16
  br i1 %12, label %21, label %42, !dbg !239

21:                                               ; preds = %15
  %22 = add i64 %17, %0
  %23 = getelementptr double, double* %2, i64 %22
  %24 = getelementptr double, double* %2, i64 %17
  %25 = add i64 %16, %0
  %26 = getelementptr double, double* %3, i64 %25
  %27 = getelementptr double, double* %3, i64 %16
  %28 = icmp ult double* %27, %23, !dbg !239
  %29 = icmp ult double* %24, %26, !dbg !239
  %30 = and i1 %28, %29, !dbg !239
  br i1 %30, label %42, label %31

31:                                               ; preds = %21, %31
  %32 = phi i64 [ %39, %31 ], [ 0, %21 ], !dbg !240
  %33 = getelementptr inbounds double, double* %19, i64 %32, !dbg !240
  %34 = bitcast double* %33 to <2 x double>*, !dbg !241
  %35 = load <2 x double>, <2 x double>* %34, align 8, !dbg !241, !tbaa !89, !alias.scope !242
  %36 = mul nsw i64 %32, %1, !dbg !240
  %37 = getelementptr inbounds double, double* %20, i64 %36, !dbg !240
  %38 = bitcast double* %37 to <2 x double>*, !dbg !245
  store <2 x double> %35, <2 x double>* %38, align 8, !dbg !245, !tbaa !89, !alias.scope !246, !noalias !242
  %39 = add nuw i64 %32, 2, !dbg !240
  %40 = icmp eq i64 %39, %13, !dbg !240
  br i1 %40, label %41, label %31, !dbg !240, !llvm.loop !248

41:                                               ; preds = %31
  br i1 %14, label %52, label %42, !dbg !239

42:                                               ; preds = %21, %15, %41
  %43 = phi i64 [ 0, %21 ], [ 0, %15 ], [ %13, %41 ]
  br label %44, !dbg !239

44:                                               ; preds = %42, %44
  %45 = phi i64 [ %50, %44 ], [ %43, %42 ]
  call void @llvm.dbg.value(metadata i64 %45, metadata !202, metadata !DIExpression()), !dbg !238
  %46 = getelementptr inbounds double, double* %19, i64 %45, !dbg !241
  %47 = load double, double* %46, align 8, !dbg !241, !tbaa !89
  %48 = mul nsw i64 %45, %1, !dbg !250
  %49 = getelementptr inbounds double, double* %20, i64 %48, !dbg !250
  store double %47, double* %49, align 8, !dbg !245, !tbaa !89
  %50 = add nuw i64 %45, 1, !dbg !240
  call void @llvm.dbg.value(metadata i64 %50, metadata !202, metadata !DIExpression()), !dbg !238
  %51 = icmp eq i64 %50, %0, !dbg !251
  br i1 %51, label %52, label %44, !dbg !239, !llvm.loop !252

52:                                               ; preds = %44, %41
  %53 = add nuw i64 %16, 1, !dbg !253
  call void @llvm.dbg.value(metadata i64 %53, metadata !200, metadata !DIExpression()), !dbg !235
  %54 = icmp eq i64 %53, %1, !dbg !236
  br i1 %54, label %55, label %15, !dbg !237, !llvm.loop !254

55:                                               ; preds = %52, %5
  ret void, !dbg !256
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #3

attributes #0 = { nounwind uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nofree norecurse nosync nounwind uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #4 = { nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!2, !3, !4, !5, !6, !7}
!llvm.ident = !{!8}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "trans.c", directory: "/afs/andrew.cmu.edu/usr4/yunhsuat/private/15513/cachelab/cachelab513-m24-Jacqueline-Tsai")
!2 = !{i32 7, !"Dwarf Version", i32 4}
!3 = !{i32 2, !"Debug Info Version", i32 3}
!4 = !{i32 1, !"wchar_size", i32 4}
!5 = !{i32 7, !"PIC Level", i32 2}
!6 = !{i32 7, !"PIE Level", i32 2}
!7 = !{i32 7, !"uwtable", i32 1}
!8 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!9 = distinct !DISubprogram(name: "registerFunctions", scope: !1, file: !1, line: 211, type: !10, scopeLine: 211, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !12)
!10 = !DISubroutineType(types: !11)
!11 = !{null}
!12 = !{}
!13 = !DILocation(line: 213, column: 5, scope: !9)
!14 = !DILocation(line: 215, column: 5, scope: !9)
!15 = !DILocation(line: 216, column: 1, scope: !9)
!16 = !DISubprogram(name: "registerTransFunction", scope: !17, file: !17, line: 99, type: !18, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized, retainedNodes: !12)
!17 = !DIFile(filename: "./cachelab.h", directory: "/afs/andrew.cmu.edu/usr4/yunhsuat/private/15513/cachelab/cachelab513-m24-Jacqueline-Tsai")
!18 = !DISubroutineType(types: !19)
!19 = !{null, !20, !32}
!20 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !21, size: 64)
!21 = !DISubroutineType(types: !22)
!22 = !{null, !23, !23, !26, !26, !31}
!23 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !24, line: 46, baseType: !25)
!24 = !DIFile(filename: "/usr/lib/llvm-14/lib/clang/14.0.0/include/stddef.h", directory: "")
!25 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!26 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !27, size: 64)
!27 = !DICompositeType(tag: DW_TAG_array_type, baseType: !28, elements: !29)
!28 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!29 = !{!30}
!30 = !DISubrange(count: -1)
!31 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !28, size: 64)
!32 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !33, size: 64)
!33 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !34)
!34 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!35 = distinct !DISubprogram(name: "transpose_submit", scope: !1, file: !1, line: 179, type: !21, scopeLine: 180, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !36)
!36 = !{!37, !38, !39, !40, !41, !42, !44}
!37 = !DILocalVariable(name: "M", arg: 1, scope: !35, file: !1, line: 179, type: !23)
!38 = !DILocalVariable(name: "N", arg: 2, scope: !35, file: !1, line: 179, type: !23)
!39 = !DILocalVariable(name: "A", arg: 3, scope: !35, file: !1, line: 179, type: !26)
!40 = !DILocalVariable(name: "B", arg: 4, scope: !35, file: !1, line: 179, type: !26)
!41 = !DILocalVariable(name: "tmp", arg: 5, scope: !35, file: !1, line: 180, type: !31)
!42 = !DILocalVariable(name: "i", scope: !43, file: !1, line: 187, type: !23)
!43 = distinct !DILexicalBlock(scope: !35, file: !1, line: 187, column: 5)
!44 = !DILocalVariable(name: "j", scope: !45, file: !1, line: 189, type: !23)
!45 = distinct !DILexicalBlock(scope: !46, file: !1, line: 189, column: 9)
!46 = distinct !DILexicalBlock(scope: !47, file: !1, line: 188, column: 31)
!47 = distinct !DILexicalBlock(scope: !43, file: !1, line: 187, column: 5)
!48 = !DILocation(line: 0, scope: !35)
!49 = !DILocation(line: 182, column: 11, scope: !50)
!50 = distinct !DILexicalBlock(scope: !35, file: !1, line: 182, column: 9)
!51 = !DILocation(line: 182, column: 16, scope: !50)
!52 = !DILocation(line: 0, scope: !43)
!53 = !DILocation(line: 187, column: 26, scope: !47)
!54 = !DILocation(line: 187, column: 5, scope: !43)
!55 = !DILocation(line: 0, scope: !45)
!56 = !DILocation(line: 189, column: 9, scope: !45)
!57 = !DILocation(line: 191, column: 19, scope: !58)
!58 = distinct !DILexicalBlock(scope: !59, file: !1, line: 191, column: 17)
!59 = distinct !DILexicalBlock(scope: !60, file: !1, line: 190, column: 35)
!60 = distinct !DILexicalBlock(scope: !45, file: !1, line: 189, column: 9)
!61 = !DILocation(line: 191, column: 17, scope: !59)
!62 = !DILocalVariable(name: "i", scope: !63, file: !1, line: 120, type: !23)
!63 = distinct !DILexicalBlock(scope: !64, file: !1, line: 120, column: 5)
!64 = distinct !DISubprogram(name: "trans_block", scope: !1, file: !1, line: 113, type: !65, scopeLine: 115, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !67)
!65 = !DISubroutineType(types: !66)
!66 = !{null, !23, !23, !26, !26, !31, !23, !23, !23, !23}
!67 = !{!68, !69, !70, !71, !72, !73, !74, !75, !76, !62, !77}
!68 = !DILocalVariable(name: "M", arg: 1, scope: !64, file: !1, line: 113, type: !23)
!69 = !DILocalVariable(name: "N", arg: 2, scope: !64, file: !1, line: 113, type: !23)
!70 = !DILocalVariable(name: "A", arg: 3, scope: !64, file: !1, line: 113, type: !26)
!71 = !DILocalVariable(name: "B", arg: 4, scope: !64, file: !1, line: 113, type: !26)
!72 = !DILocalVariable(name: "tmp", arg: 5, scope: !64, file: !1, line: 114, type: !31)
!73 = !DILocalVariable(name: "M_start", arg: 6, scope: !64, file: !1, line: 114, type: !23)
!74 = !DILocalVariable(name: "N_start", arg: 7, scope: !64, file: !1, line: 114, type: !23)
!75 = !DILocalVariable(name: "M_end", arg: 8, scope: !64, file: !1, line: 115, type: !23)
!76 = !DILocalVariable(name: "N_end", arg: 9, scope: !64, file: !1, line: 115, type: !23)
!77 = !DILocalVariable(name: "j", scope: !78, file: !1, line: 121, type: !23)
!78 = distinct !DILexicalBlock(scope: !79, file: !1, line: 121, column: 9)
!79 = distinct !DILexicalBlock(scope: !80, file: !1, line: 120, column: 46)
!80 = distinct !DILexicalBlock(scope: !63, file: !1, line: 120, column: 5)
!81 = !DILocation(line: 0, scope: !63, inlinedAt: !82)
!82 = distinct !DILocation(line: 192, column: 17, scope: !83)
!83 = distinct !DILexicalBlock(scope: !58, file: !1, line: 191, column: 25)
!84 = !DILocation(line: 0, scope: !78, inlinedAt: !82)
!85 = !DILocation(line: 121, column: 9, scope: !78, inlinedAt: !82)
!86 = !DILocation(line: 122, column: 23, scope: !87, inlinedAt: !82)
!87 = distinct !DILexicalBlock(scope: !88, file: !1, line: 121, column: 50)
!88 = distinct !DILexicalBlock(scope: !78, file: !1, line: 121, column: 9)
!89 = !{!90, !90, i64 0}
!90 = !{!"double", !91, i64 0}
!91 = !{!"omnipotent char", !92, i64 0}
!92 = !{!"Simple C/C++ TBAA"}
!93 = !DILocation(line: 122, column: 13, scope: !87, inlinedAt: !82)
!94 = !DILocation(line: 122, column: 21, scope: !87, inlinedAt: !82)
!95 = !DILocation(line: 121, column: 46, scope: !88, inlinedAt: !82)
!96 = !DILocation(line: 121, column: 36, scope: !88, inlinedAt: !82)
!97 = distinct !{!97, !85, !98, !99}
!98 = !DILocation(line: 123, column: 9, scope: !78, inlinedAt: !82)
!99 = !{!"llvm.loop.unroll.disable"}
!100 = !DILocation(line: 120, column: 42, scope: !80, inlinedAt: !82)
!101 = !DILocation(line: 120, column: 32, scope: !80, inlinedAt: !82)
!102 = !DILocation(line: 120, column: 5, scope: !63, inlinedAt: !82)
!103 = distinct !{!103, !102, !104, !99}
!104 = !DILocation(line: 124, column: 5, scope: !63, inlinedAt: !82)
!105 = !DILocalVariable(name: "i", scope: !106, file: !1, line: 152, type: !23)
!106 = distinct !DILexicalBlock(scope: !107, file: !1, line: 152, column: 5)
!107 = distinct !DISubprogram(name: "trans_block_diag", scope: !1, file: !1, line: 143, type: !65, scopeLine: 146, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !108)
!108 = !{!109, !110, !111, !112, !113, !114, !115, !116, !117, !105, !118, !121, !123, !125, !127, !130}
!109 = !DILocalVariable(name: "M", arg: 1, scope: !107, file: !1, line: 143, type: !23)
!110 = !DILocalVariable(name: "N", arg: 2, scope: !107, file: !1, line: 143, type: !23)
!111 = !DILocalVariable(name: "A", arg: 3, scope: !107, file: !1, line: 143, type: !26)
!112 = !DILocalVariable(name: "B", arg: 4, scope: !107, file: !1, line: 144, type: !26)
!113 = !DILocalVariable(name: "tmp", arg: 5, scope: !107, file: !1, line: 144, type: !31)
!114 = !DILocalVariable(name: "M_start", arg: 6, scope: !107, file: !1, line: 145, type: !23)
!115 = !DILocalVariable(name: "N_start", arg: 7, scope: !107, file: !1, line: 145, type: !23)
!116 = !DILocalVariable(name: "M_end", arg: 8, scope: !107, file: !1, line: 145, type: !23)
!117 = !DILocalVariable(name: "N_end", arg: 9, scope: !107, file: !1, line: 146, type: !23)
!118 = !DILocalVariable(name: "tmp_set", scope: !119, file: !1, line: 153, type: !23)
!119 = distinct !DILexicalBlock(scope: !120, file: !1, line: 152, column: 50)
!120 = distinct !DILexicalBlock(scope: !106, file: !1, line: 152, column: 5)
!121 = !DILocalVariable(name: "j", scope: !122, file: !1, line: 154, type: !23)
!122 = distinct !DILexicalBlock(scope: !119, file: !1, line: 154, column: 9)
!123 = !DILocalVariable(name: "j", scope: !124, file: !1, line: 159, type: !23)
!124 = distinct !DILexicalBlock(scope: !107, file: !1, line: 159, column: 5)
!125 = !DILocalVariable(name: "i", scope: !126, file: !1, line: 164, type: !23)
!126 = distinct !DILexicalBlock(scope: !107, file: !1, line: 164, column: 5)
!127 = !DILocalVariable(name: "tmp_set", scope: !128, file: !1, line: 165, type: !23)
!128 = distinct !DILexicalBlock(scope: !129, file: !1, line: 164, column: 50)
!129 = distinct !DILexicalBlock(scope: !126, file: !1, line: 164, column: 5)
!130 = !DILocalVariable(name: "j", scope: !131, file: !1, line: 166, type: !23)
!131 = distinct !DILexicalBlock(scope: !128, file: !1, line: 166, column: 9)
!132 = !DILocation(line: 0, scope: !106, inlinedAt: !133)
!133 = distinct !DILocation(line: 195, column: 17, scope: !134)
!134 = distinct !DILexicalBlock(scope: !58, file: !1, line: 194, column: 20)
!135 = !DILocation(line: 153, column: 55, scope: !119, inlinedAt: !133)
!136 = !DILocation(line: 0, scope: !119, inlinedAt: !133)
!137 = !DILocation(line: 0, scope: !122, inlinedAt: !133)
!138 = !DILocation(line: 154, column: 9, scope: !122, inlinedAt: !133)
!139 = !DILocation(line: 155, column: 48, scope: !140, inlinedAt: !133)
!140 = distinct !DILexicalBlock(scope: !141, file: !1, line: 154, column: 50)
!141 = distinct !DILexicalBlock(scope: !122, file: !1, line: 154, column: 9)
!142 = !DILocation(line: 155, column: 29, scope: !140, inlinedAt: !133)
!143 = !DILocation(line: 155, column: 13, scope: !140, inlinedAt: !133)
!144 = !DILocation(line: 155, column: 46, scope: !140, inlinedAt: !133)
!145 = !DILocation(line: 154, column: 46, scope: !141, inlinedAt: !133)
!146 = !DILocation(line: 154, column: 36, scope: !141, inlinedAt: !133)
!147 = distinct !{!147, !138, !148, !99}
!148 = !DILocation(line: 156, column: 9, scope: !122, inlinedAt: !133)
!149 = !DILocation(line: 152, column: 46, scope: !120, inlinedAt: !133)
!150 = !DILocation(line: 152, column: 36, scope: !120, inlinedAt: !133)
!151 = !DILocation(line: 152, column: 5, scope: !106, inlinedAt: !133)
!152 = distinct !{!152, !151, !153, !99}
!153 = !DILocation(line: 157, column: 5, scope: !106, inlinedAt: !133)
!154 = !DILocation(line: 160, column: 25, scope: !155, inlinedAt: !133)
!155 = distinct !DILexicalBlock(scope: !156, file: !1, line: 159, column: 50)
!156 = distinct !DILexicalBlock(scope: !124, file: !1, line: 159, column: 5)
!157 = !DILocation(line: 160, column: 9, scope: !155, inlinedAt: !133)
!158 = !DILocation(line: 160, column: 23, scope: !155, inlinedAt: !133)
!159 = !DILocation(line: 0, scope: !124, inlinedAt: !133)
!160 = !DILocation(line: 159, column: 34, scope: !156, inlinedAt: !133)
!161 = !DILocation(line: 159, column: 5, scope: !124, inlinedAt: !133)
!162 = distinct !{!162, !161, !163, !99}
!163 = !DILocation(line: 161, column: 5, scope: !124, inlinedAt: !133)
!164 = !DILocation(line: 162, column: 27, scope: !107, inlinedAt: !133)
!165 = !DILocation(line: 162, column: 25, scope: !107, inlinedAt: !133)
!166 = !DILocation(line: 0, scope: !126, inlinedAt: !133)
!167 = !DILocation(line: 164, column: 5, scope: !126, inlinedAt: !133)
!168 = !DILocation(line: 165, column: 55, scope: !128, inlinedAt: !133)
!169 = !DILocation(line: 0, scope: !128, inlinedAt: !133)
!170 = !DILocation(line: 0, scope: !131, inlinedAt: !133)
!171 = !DILocation(line: 166, column: 9, scope: !131, inlinedAt: !133)
!172 = !DILocation(line: 167, column: 39, scope: !173, inlinedAt: !133)
!173 = distinct !DILexicalBlock(scope: !174, file: !1, line: 166, column: 50)
!174 = distinct !DILexicalBlock(scope: !131, file: !1, line: 166, column: 9)
!175 = !DILocation(line: 167, column: 23, scope: !173, inlinedAt: !133)
!176 = !DILocation(line: 167, column: 13, scope: !173, inlinedAt: !133)
!177 = !DILocation(line: 167, column: 21, scope: !173, inlinedAt: !133)
!178 = !DILocation(line: 166, column: 46, scope: !174, inlinedAt: !133)
!179 = !DILocation(line: 166, column: 36, scope: !174, inlinedAt: !133)
!180 = distinct !{!180, !171, !181, !99}
!181 = !DILocation(line: 168, column: 9, scope: !131, inlinedAt: !133)
!182 = !DILocation(line: 164, column: 46, scope: !129, inlinedAt: !133)
!183 = !DILocation(line: 164, column: 36, scope: !129, inlinedAt: !133)
!184 = distinct !{!184, !167, !185, !99}
!185 = !DILocation(line: 169, column: 5, scope: !126, inlinedAt: !133)
!186 = !DILocation(line: 190, column: 16, scope: !60)
!187 = !DILocation(line: 189, column: 30, scope: !60)
!188 = distinct !{!188, !56, !189, !99}
!189 = !DILocation(line: 198, column: 9, scope: !45)
!190 = !DILocation(line: 0, scope: !64, inlinedAt: !82)
!191 = distinct !{!191, !54, !192, !99}
!192 = !DILocation(line: 199, column: 5, scope: !43)
!193 = !DILocalVariable(name: "M", arg: 1, scope: !194, file: !1, line: 82, type: !23)
!194 = distinct !DISubprogram(name: "trans_basic", scope: !1, file: !1, line: 82, type: !21, scopeLine: 83, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !195)
!195 = !{!193, !196, !197, !198, !199, !200, !202}
!196 = !DILocalVariable(name: "N", arg: 2, scope: !194, file: !1, line: 82, type: !23)
!197 = !DILocalVariable(name: "A", arg: 3, scope: !194, file: !1, line: 82, type: !26)
!198 = !DILocalVariable(name: "B", arg: 4, scope: !194, file: !1, line: 82, type: !26)
!199 = !DILocalVariable(name: "tmp", arg: 5, scope: !194, file: !1, line: 83, type: !31)
!200 = !DILocalVariable(name: "i", scope: !201, file: !1, line: 87, type: !23)
!201 = distinct !DILexicalBlock(scope: !194, file: !1, line: 87, column: 5)
!202 = !DILocalVariable(name: "j", scope: !203, file: !1, line: 88, type: !23)
!203 = distinct !DILexicalBlock(scope: !204, file: !1, line: 88, column: 9)
!204 = distinct !DILexicalBlock(scope: !205, file: !1, line: 87, column: 36)
!205 = distinct !DILexicalBlock(scope: !201, file: !1, line: 87, column: 5)
!206 = !DILocation(line: 0, scope: !194, inlinedAt: !207)
!207 = distinct !DILocation(line: 183, column: 9, scope: !208)
!208 = distinct !DILexicalBlock(scope: !50, file: !1, line: 182, column: 31)
!209 = !DILocation(line: 0, scope: !201, inlinedAt: !207)
!210 = !DILocation(line: 87, column: 26, scope: !205, inlinedAt: !207)
!211 = !DILocation(line: 87, column: 5, scope: !201, inlinedAt: !207)
!212 = !DILocation(line: 0, scope: !203, inlinedAt: !207)
!213 = !DILocation(line: 88, column: 9, scope: !203, inlinedAt: !207)
!214 = !DILocation(line: 88, column: 36, scope: !215, inlinedAt: !207)
!215 = distinct !DILexicalBlock(scope: !203, file: !1, line: 88, column: 9)
!216 = !DILocation(line: 89, column: 23, scope: !217, inlinedAt: !207)
!217 = distinct !DILexicalBlock(scope: !215, file: !1, line: 88, column: 40)
!218 = !{!219}
!219 = distinct !{!219, !220}
!220 = distinct !{!220, !"LVerDomain"}
!221 = !DILocation(line: 89, column: 21, scope: !217, inlinedAt: !207)
!222 = !{!223}
!223 = distinct !{!223, !220}
!224 = distinct !{!224, !213, !225, !99, !226}
!225 = !DILocation(line: 90, column: 9, scope: !203, inlinedAt: !207)
!226 = !{!"llvm.loop.isvectorized", i32 1}
!227 = !DILocation(line: 89, column: 13, scope: !217, inlinedAt: !207)
!228 = !DILocation(line: 88, column: 30, scope: !215, inlinedAt: !207)
!229 = distinct !{!229, !213, !225, !99, !226}
!230 = !DILocation(line: 87, column: 32, scope: !205, inlinedAt: !207)
!231 = distinct !{!231, !211, !232, !99}
!232 = !DILocation(line: 91, column: 5, scope: !201, inlinedAt: !207)
!233 = !DILocation(line: 202, column: 1, scope: !35)
!234 = !DILocation(line: 0, scope: !194)
!235 = !DILocation(line: 0, scope: !201)
!236 = !DILocation(line: 87, column: 26, scope: !205)
!237 = !DILocation(line: 87, column: 5, scope: !201)
!238 = !DILocation(line: 0, scope: !203)
!239 = !DILocation(line: 88, column: 9, scope: !203)
!240 = !DILocation(line: 88, column: 36, scope: !215)
!241 = !DILocation(line: 89, column: 23, scope: !217)
!242 = !{!243}
!243 = distinct !{!243, !244}
!244 = distinct !{!244, !"LVerDomain"}
!245 = !DILocation(line: 89, column: 21, scope: !217)
!246 = !{!247}
!247 = distinct !{!247, !244}
!248 = distinct !{!248, !239, !249, !99, !226}
!249 = !DILocation(line: 90, column: 9, scope: !203)
!250 = !DILocation(line: 89, column: 13, scope: !217)
!251 = !DILocation(line: 88, column: 30, scope: !215)
!252 = distinct !{!252, !239, !249, !99, !226}
!253 = !DILocation(line: 87, column: 32, scope: !205)
!254 = distinct !{!254, !237, !255, !99}
!255 = !DILocation(line: 91, column: 5, scope: !201)
!256 = !DILocation(line: 94, column: 1, scope: !194)
