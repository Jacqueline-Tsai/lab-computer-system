; ModuleID = 'sfs-disk.c'
source_filename = "sfs-disk.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { %struct.__pthread_internal_list*, %struct.__pthread_internal_list* }
%struct.sfs_mem_filedesc_t = type { %struct.sfs_mem_file_t*, i32, i32, i64 }
%struct.sfs_mem_file_t = type { i32, i32, %struct.sfs_dir_entry_t* }
%struct.sfs_dir_entry_t = type { i32, i32, [24 x i8] }
%struct.sfs_filesystem_t = type { [8 x i8], i32, i32, i32, [12 x i8], [15 x %struct.sfs_dir_entry_t] }
%struct.sfs_block_hdr_t = type { [4 x i8], i32, i32 }
%struct.sfs_block_file_t = type { %struct.sfs_block_hdr_t, [500 x i8] }

@sfs_mutexes = dso_local global %union.pthread_mutex_t zeroinitializer, align 8
@openFileDescTable = internal unnamed_addr global [32 x %struct.sfs_mem_filedesc_t*] zeroinitializer, align 16
@openFileTable = internal unnamed_addr global [15 x %struct.sfs_mem_file_t*] zeroinitializer, align 16
@.str = private unnamed_addr constant [20 x i8] c"currPos <= fileSize\00", align 1
@.str.1 = private unnamed_addr constant [11 x i8] c"sfs-disk.c\00", align 1
@__PRETTY_FUNCTION__.sfs_read = private unnamed_addr constant [38 x i8] c"ssize_t sfs_read(int, char *, size_t)\00", align 1
@.str.2 = private unnamed_addr constant [18 x i8] c"diskBlock != NULL\00", align 1
@__PRETTY_FUNCTION__.sfs_write = private unnamed_addr constant [45 x i8] c"ssize_t sfs_write(int, const char *, size_t)\00", align 1
@.str.3 = private unnamed_addr constant [16 x i8] c"addlBlocks >= 1\00", align 1
@.str.4 = private unnamed_addr constant [5 x i8] c"SFF\E6\00", align 1
@.str.5 = private unnamed_addr constant [16 x i8] c"firstNewId != 0\00", align 1
@.str.6 = private unnamed_addr constant [27 x i8] c"endPos < SFS_MAX_FILE_SIZE\00", align 1
@.str.7 = private unnamed_addr constant [36 x i8] c"len + 1 <= SFS_FILE_NAME_SIZE_LIMIT\00", align 1
@__PRETTY_FUNCTION__.createFile = private unnamed_addr constant [34 x i8] c"int createFile(const char *, int)\00", align 1
@.str.8 = private unnamed_addr constant [5 x i8] c"SFU\F5\00", align 1
@.str.9 = private unnamed_addr constant [58 x i8] c"memcmp(b->type, SFS_BLOCK_TYPE_FREE, sizeof b->type) != 0\00", align 1
@__PRETTY_FUNCTION__.freeBlocks = private unnamed_addr constant [26 x i8] c"void freeBlocks(block_id)\00", align 1

; Function Attrs: nounwind uwtable
define dso_local i32 @sfs_open(i8* nocapture noundef readonly %0) local_unnamed_addr #0 {
  %2 = tail call i64 @strnlen(i8* noundef %0, i64 noundef 25) #14
  %3 = add i64 %2, -24
  %4 = icmp ult i64 %3, -25
  br i1 %4, label %210, label %5

5:                                                ; preds = %1
  %6 = tail call i32 @getSFSStatus() #15
  %7 = icmp slt i32 %6, 0
  br i1 %7, label %210, label %8

8:                                                ; preds = %5
  %9 = tail call %struct.sfs_filesystem_t* @accessSuperBlock() #15
  %10 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %9, i64 0, i32 5, i64 0, i32 0
  %11 = load i32, i32* %10, align 4, !tbaa !5
  %12 = icmp eq i32 %11, 0
  br i1 %12, label %20, label %13

13:                                               ; preds = %8
  %14 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %9, i64 0, i32 5, i64 0, i32 2, i64 0
  %15 = tail call i32 @strcmp(i8* noundef nonnull %14, i8* noundef nonnull dereferenceable(1) %0) #14
  %16 = icmp eq i32 %15, 0
  br i1 %16, label %17, label %20

17:                                               ; preds = %167, %156, %145, %134, %123, %112, %101, %90, %79, %68, %57, %46, %35, %25, %13
  %18 = phi i32 [ 0, %13 ], [ 1, %25 ], [ 2, %35 ], [ 3, %46 ], [ 4, %57 ], [ 5, %68 ], [ 6, %79 ], [ 7, %90 ], [ 8, %101 ], [ 9, %112 ], [ 10, %123 ], [ 11, %134 ], [ 12, %145 ], [ 13, %156 ], [ 14, %167 ]
  %19 = tail call fastcc i32 @addOpenFileEntry(i32 noundef %18)
  br label %210

20:                                               ; preds = %13, %8
  %21 = phi i32 [ -1, %13 ], [ 0, %8 ]
  %22 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %9, i64 0, i32 5, i64 1, i32 0
  %23 = load i32, i32* %22, align 4, !tbaa !5
  %24 = icmp eq i32 %23, 0
  br i1 %24, label %29, label %25

25:                                               ; preds = %20
  %26 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %9, i64 0, i32 5, i64 1, i32 2, i64 0
  %27 = tail call i32 @strcmp(i8* noundef nonnull %26, i8* noundef nonnull dereferenceable(1) %0) #14
  %28 = icmp eq i32 %27, 0
  br i1 %28, label %17, label %29

29:                                               ; preds = %25, %20
  %30 = phi i32 [ -1, %25 ], [ 1, %20 ]
  %31 = select i1 %12, i32 %21, i32 %30
  %32 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %9, i64 0, i32 5, i64 2, i32 0
  %33 = load i32, i32* %32, align 4, !tbaa !5
  %34 = icmp eq i32 %33, 0
  br i1 %34, label %39, label %35

35:                                               ; preds = %29
  %36 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %9, i64 0, i32 5, i64 2, i32 2, i64 0
  %37 = tail call i32 @strcmp(i8* noundef nonnull %36, i8* noundef nonnull dereferenceable(1) %0) #14
  %38 = icmp eq i32 %37, 0
  br i1 %38, label %17, label %39

39:                                               ; preds = %35, %29
  %40 = phi i32 [ -1, %35 ], [ 2, %29 ]
  %41 = icmp eq i32 %31, -1
  %42 = select i1 %41, i32 %40, i32 %31
  %43 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %9, i64 0, i32 5, i64 3, i32 0
  %44 = load i32, i32* %43, align 4, !tbaa !5
  %45 = icmp eq i32 %44, 0
  br i1 %45, label %50, label %46

46:                                               ; preds = %39
  %47 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %9, i64 0, i32 5, i64 3, i32 2, i64 0
  %48 = tail call i32 @strcmp(i8* noundef nonnull %47, i8* noundef nonnull dereferenceable(1) %0) #14
  %49 = icmp eq i32 %48, 0
  br i1 %49, label %17, label %50

50:                                               ; preds = %46, %39
  %51 = phi i32 [ -1, %46 ], [ 3, %39 ]
  %52 = icmp eq i32 %42, -1
  %53 = select i1 %52, i32 %51, i32 %42
  %54 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %9, i64 0, i32 5, i64 4, i32 0
  %55 = load i32, i32* %54, align 4, !tbaa !5
  %56 = icmp eq i32 %55, 0
  br i1 %56, label %61, label %57

57:                                               ; preds = %50
  %58 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %9, i64 0, i32 5, i64 4, i32 2, i64 0
  %59 = tail call i32 @strcmp(i8* noundef nonnull %58, i8* noundef nonnull dereferenceable(1) %0) #14
  %60 = icmp eq i32 %59, 0
  br i1 %60, label %17, label %61

61:                                               ; preds = %57, %50
  %62 = phi i32 [ -1, %57 ], [ 4, %50 ]
  %63 = icmp eq i32 %53, -1
  %64 = select i1 %63, i32 %62, i32 %53
  %65 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %9, i64 0, i32 5, i64 5, i32 0
  %66 = load i32, i32* %65, align 4, !tbaa !5
  %67 = icmp eq i32 %66, 0
  br i1 %67, label %72, label %68

68:                                               ; preds = %61
  %69 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %9, i64 0, i32 5, i64 5, i32 2, i64 0
  %70 = tail call i32 @strcmp(i8* noundef nonnull %69, i8* noundef nonnull dereferenceable(1) %0) #14
  %71 = icmp eq i32 %70, 0
  br i1 %71, label %17, label %72

72:                                               ; preds = %68, %61
  %73 = phi i32 [ -1, %68 ], [ 5, %61 ]
  %74 = icmp eq i32 %64, -1
  %75 = select i1 %74, i32 %73, i32 %64
  %76 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %9, i64 0, i32 5, i64 6, i32 0
  %77 = load i32, i32* %76, align 4, !tbaa !5
  %78 = icmp eq i32 %77, 0
  br i1 %78, label %83, label %79

79:                                               ; preds = %72
  %80 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %9, i64 0, i32 5, i64 6, i32 2, i64 0
  %81 = tail call i32 @strcmp(i8* noundef nonnull %80, i8* noundef nonnull dereferenceable(1) %0) #14
  %82 = icmp eq i32 %81, 0
  br i1 %82, label %17, label %83

83:                                               ; preds = %79, %72
  %84 = phi i32 [ -1, %79 ], [ 6, %72 ]
  %85 = icmp eq i32 %75, -1
  %86 = select i1 %85, i32 %84, i32 %75
  %87 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %9, i64 0, i32 5, i64 7, i32 0
  %88 = load i32, i32* %87, align 4, !tbaa !5
  %89 = icmp eq i32 %88, 0
  br i1 %89, label %94, label %90

90:                                               ; preds = %83
  %91 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %9, i64 0, i32 5, i64 7, i32 2, i64 0
  %92 = tail call i32 @strcmp(i8* noundef nonnull %91, i8* noundef nonnull dereferenceable(1) %0) #14
  %93 = icmp eq i32 %92, 0
  br i1 %93, label %17, label %94

94:                                               ; preds = %90, %83
  %95 = phi i32 [ -1, %90 ], [ 7, %83 ]
  %96 = icmp eq i32 %86, -1
  %97 = select i1 %96, i32 %95, i32 %86
  %98 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %9, i64 0, i32 5, i64 8, i32 0
  %99 = load i32, i32* %98, align 4, !tbaa !5
  %100 = icmp eq i32 %99, 0
  br i1 %100, label %105, label %101

101:                                              ; preds = %94
  %102 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %9, i64 0, i32 5, i64 8, i32 2, i64 0
  %103 = tail call i32 @strcmp(i8* noundef nonnull %102, i8* noundef nonnull dereferenceable(1) %0) #14
  %104 = icmp eq i32 %103, 0
  br i1 %104, label %17, label %105

105:                                              ; preds = %101, %94
  %106 = phi i32 [ -1, %101 ], [ 8, %94 ]
  %107 = icmp eq i32 %97, -1
  %108 = select i1 %107, i32 %106, i32 %97
  %109 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %9, i64 0, i32 5, i64 9, i32 0
  %110 = load i32, i32* %109, align 4, !tbaa !5
  %111 = icmp eq i32 %110, 0
  br i1 %111, label %116, label %112

112:                                              ; preds = %105
  %113 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %9, i64 0, i32 5, i64 9, i32 2, i64 0
  %114 = tail call i32 @strcmp(i8* noundef nonnull %113, i8* noundef nonnull dereferenceable(1) %0) #14
  %115 = icmp eq i32 %114, 0
  br i1 %115, label %17, label %116

116:                                              ; preds = %112, %105
  %117 = phi i32 [ -1, %112 ], [ 9, %105 ]
  %118 = icmp eq i32 %108, -1
  %119 = select i1 %118, i32 %117, i32 %108
  %120 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %9, i64 0, i32 5, i64 10, i32 0
  %121 = load i32, i32* %120, align 4, !tbaa !5
  %122 = icmp eq i32 %121, 0
  br i1 %122, label %127, label %123

123:                                              ; preds = %116
  %124 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %9, i64 0, i32 5, i64 10, i32 2, i64 0
  %125 = tail call i32 @strcmp(i8* noundef nonnull %124, i8* noundef nonnull dereferenceable(1) %0) #14
  %126 = icmp eq i32 %125, 0
  br i1 %126, label %17, label %127

127:                                              ; preds = %123, %116
  %128 = phi i32 [ -1, %123 ], [ 10, %116 ]
  %129 = icmp eq i32 %119, -1
  %130 = select i1 %129, i32 %128, i32 %119
  %131 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %9, i64 0, i32 5, i64 11, i32 0
  %132 = load i32, i32* %131, align 4, !tbaa !5
  %133 = icmp eq i32 %132, 0
  br i1 %133, label %138, label %134

134:                                              ; preds = %127
  %135 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %9, i64 0, i32 5, i64 11, i32 2, i64 0
  %136 = tail call i32 @strcmp(i8* noundef nonnull %135, i8* noundef nonnull dereferenceable(1) %0) #14
  %137 = icmp eq i32 %136, 0
  br i1 %137, label %17, label %138

138:                                              ; preds = %134, %127
  %139 = phi i32 [ -1, %134 ], [ 11, %127 ]
  %140 = icmp eq i32 %130, -1
  %141 = select i1 %140, i32 %139, i32 %130
  %142 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %9, i64 0, i32 5, i64 12, i32 0
  %143 = load i32, i32* %142, align 4, !tbaa !5
  %144 = icmp eq i32 %143, 0
  br i1 %144, label %149, label %145

145:                                              ; preds = %138
  %146 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %9, i64 0, i32 5, i64 12, i32 2, i64 0
  %147 = tail call i32 @strcmp(i8* noundef nonnull %146, i8* noundef nonnull dereferenceable(1) %0) #14
  %148 = icmp eq i32 %147, 0
  br i1 %148, label %17, label %149

149:                                              ; preds = %145, %138
  %150 = phi i32 [ -1, %145 ], [ 12, %138 ]
  %151 = icmp eq i32 %141, -1
  %152 = select i1 %151, i32 %150, i32 %141
  %153 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %9, i64 0, i32 5, i64 13, i32 0
  %154 = load i32, i32* %153, align 4, !tbaa !5
  %155 = icmp eq i32 %154, 0
  br i1 %155, label %160, label %156

156:                                              ; preds = %149
  %157 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %9, i64 0, i32 5, i64 13, i32 2, i64 0
  %158 = tail call i32 @strcmp(i8* noundef nonnull %157, i8* noundef nonnull dereferenceable(1) %0) #14
  %159 = icmp eq i32 %158, 0
  br i1 %159, label %17, label %160

160:                                              ; preds = %156, %149
  %161 = phi i32 [ -1, %156 ], [ 13, %149 ]
  %162 = icmp eq i32 %152, -1
  %163 = select i1 %162, i32 %161, i32 %152
  %164 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %9, i64 0, i32 5, i64 14, i32 0
  %165 = load i32, i32* %164, align 4, !tbaa !5
  %166 = icmp eq i32 %165, 0
  br i1 %166, label %171, label %167

167:                                              ; preds = %160
  %168 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %9, i64 0, i32 5, i64 14, i32 2, i64 0
  %169 = tail call i32 @strcmp(i8* noundef nonnull %168, i8* noundef nonnull dereferenceable(1) %0) #14
  %170 = icmp eq i32 %169, 0
  br i1 %170, label %17, label %171

171:                                              ; preds = %167, %160
  %172 = phi i32 [ -1, %167 ], [ 14, %160 ]
  %173 = icmp eq i32 %163, -1
  %174 = select i1 %173, i32 %172, i32 %163
  %175 = icmp eq i32 %174, -1
  br i1 %175, label %210, label %176

176:                                              ; preds = %171
  %177 = tail call %struct.sfs_filesystem_t* @accessSuperBlock() #15
  %178 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %177, i64 0, i32 2
  %179 = load i32, i32* %178, align 4, !tbaa !10
  %180 = icmp eq i32 %179, 0
  br i1 %180, label %210, label %181

181:                                              ; preds = %176
  %182 = tail call %struct.sfs_block_hdr_t* @accessFreeBlock(i32 noundef %179) #15
  %183 = getelementptr inbounds %struct.sfs_block_hdr_t, %struct.sfs_block_hdr_t* %182, i64 0, i32 2
  %184 = load i32, i32* %183, align 4, !tbaa !12
  %185 = icmp eq i32 %184, 0
  br i1 %185, label %189, label %186

186:                                              ; preds = %181
  %187 = tail call %struct.sfs_block_hdr_t* @accessFreeBlock(i32 noundef %184) #15
  %188 = getelementptr inbounds %struct.sfs_block_hdr_t, %struct.sfs_block_hdr_t* %187, i64 0, i32 1
  store i32 0, i32* %188, align 4, !tbaa !14
  store i32 0, i32* %183, align 4, !tbaa !12
  br label %189

189:                                              ; preds = %186, %181
  store i32 %184, i32* %178, align 4, !tbaa !10
  br label %190

190:                                              ; preds = %190, %189
  %191 = phi %struct.sfs_block_hdr_t* [ %194, %190 ], [ %182, %189 ]
  tail call void @setBlockType(%struct.sfs_block_hdr_t* noundef nonnull %191, i8* noundef getelementptr inbounds ([5 x i8], [5 x i8]* @.str.4, i64 0, i64 0)) #15
  %192 = getelementptr inbounds %struct.sfs_block_hdr_t, %struct.sfs_block_hdr_t* %191, i64 0, i32 2
  %193 = load i32, i32* %192, align 4, !tbaa !12
  %194 = tail call %struct.sfs_block_hdr_t* @accessFreeBlock(i32 noundef %193) #15
  %195 = icmp eq %struct.sfs_block_hdr_t* %194, null
  br i1 %195, label %196, label %190, !llvm.loop !15

196:                                              ; preds = %190
  %197 = tail call %struct.sfs_filesystem_t* @accessSuperBlock() #15
  %198 = sext i32 %174 to i64
  %199 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %197, i64 0, i32 5, i64 %198, i32 0
  store i32 %179, i32* %199, align 4, !tbaa !5
  %200 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %197, i64 0, i32 5, i64 %198, i32 1
  store i32 0, i32* %200, align 4, !tbaa !17
  %201 = tail call i64 @strlen(i8* noundef nonnull dereferenceable(1) %0) #14
  %202 = add i64 %201, 1
  %203 = icmp ult i64 %202, 25
  br i1 %203, label %205, label %204

204:                                              ; preds = %196
  tail call void @__assert_fail(i8* noundef getelementptr inbounds ([36 x i8], [36 x i8]* @.str.7, i64 0, i64 0), i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str.1, i64 0, i64 0), i32 noundef 272, i8* noundef getelementptr inbounds ([34 x i8], [34 x i8]* @__PRETTY_FUNCTION__.createFile, i64 0, i64 0)) #16
  unreachable

205:                                              ; preds = %196
  %206 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %197, i64 0, i32 5, i64 %198, i32 2, i64 0
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 4 %206, i8* align 1 %0, i64 %201, i1 false) #15
  %207 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %197, i64 0, i32 5, i64 %198, i32 2, i64 %201
  %208 = sub nsw i64 24, %201
  tail call void @llvm.memset.p0i8.i64(i8* nonnull align 1 %207, i8 0, i64 %208, i1 false) #15
  %209 = tail call fastcc i32 @addOpenFileEntry(i32 noundef %174) #15
  br label %210

210:                                              ; preds = %205, %176, %17, %171, %5, %1
  %211 = phi i32 [ -36, %1 ], [ -123, %5 ], [ %19, %17 ], [ -28, %171 ], [ %209, %205 ], [ -28, %176 ]
  ret i32 %211
}

; Function Attrs: argmemonly mustprogress nofree nounwind readonly willreturn
declare i64 @strnlen(i8* nocapture noundef, i64 noundef) local_unnamed_addr #1

declare i32 @getSFSStatus() local_unnamed_addr #2

declare %struct.sfs_filesystem_t* @accessSuperBlock() local_unnamed_addr #2

; Function Attrs: argmemonly mustprogress nofree nounwind readonly willreturn
declare i32 @strcmp(i8* nocapture noundef, i8* nocapture noundef) local_unnamed_addr #1

; Function Attrs: nounwind uwtable
define internal fastcc i32 @addOpenFileEntry(i32 noundef %0) unnamed_addr #0 {
  %2 = load %struct.sfs_mem_filedesc_t*, %struct.sfs_mem_filedesc_t** getelementptr inbounds ([32 x %struct.sfs_mem_filedesc_t*], [32 x %struct.sfs_mem_filedesc_t*]* @openFileDescTable, i64 0, i64 0), align 16, !tbaa !18
  %3 = icmp eq %struct.sfs_mem_filedesc_t* %2, null
  br i1 %3, label %4, label %8

4:                                                ; preds = %98, %95, %92, %89, %86, %83, %80, %77, %74, %71, %68, %65, %62, %59, %56, %53, %50, %47, %44, %41, %38, %35, %32, %29, %26, %23, %20, %17, %14, %11, %8, %1
  %5 = phi i32 [ 0, %1 ], [ 1, %8 ], [ 2, %11 ], [ 3, %14 ], [ 4, %17 ], [ 5, %20 ], [ 6, %23 ], [ 7, %26 ], [ 8, %29 ], [ 9, %32 ], [ 10, %35 ], [ 11, %38 ], [ 12, %41 ], [ 13, %44 ], [ 14, %47 ], [ 15, %50 ], [ 16, %53 ], [ 17, %56 ], [ 18, %59 ], [ 19, %62 ], [ 20, %65 ], [ 21, %68 ], [ 22, %71 ], [ 23, %74 ], [ 24, %77 ], [ 25, %80 ], [ 26, %83 ], [ 27, %86 ], [ 28, %89 ], [ 29, %92 ], [ 30, %95 ], [ 31, %98 ]
  %6 = tail call noalias dereferenceable_or_null(24) i8* @malloc(i64 noundef 24) #15
  %7 = icmp eq i8* %6, null
  br i1 %7, label %139, label %101

8:                                                ; preds = %1
  %9 = load %struct.sfs_mem_filedesc_t*, %struct.sfs_mem_filedesc_t** getelementptr inbounds ([32 x %struct.sfs_mem_filedesc_t*], [32 x %struct.sfs_mem_filedesc_t*]* @openFileDescTable, i64 0, i64 1), align 8, !tbaa !18
  %10 = icmp eq %struct.sfs_mem_filedesc_t* %9, null
  br i1 %10, label %4, label %11

11:                                               ; preds = %8
  %12 = load %struct.sfs_mem_filedesc_t*, %struct.sfs_mem_filedesc_t** getelementptr inbounds ([32 x %struct.sfs_mem_filedesc_t*], [32 x %struct.sfs_mem_filedesc_t*]* @openFileDescTable, i64 0, i64 2), align 16, !tbaa !18
  %13 = icmp eq %struct.sfs_mem_filedesc_t* %12, null
  br i1 %13, label %4, label %14

14:                                               ; preds = %11
  %15 = load %struct.sfs_mem_filedesc_t*, %struct.sfs_mem_filedesc_t** getelementptr inbounds ([32 x %struct.sfs_mem_filedesc_t*], [32 x %struct.sfs_mem_filedesc_t*]* @openFileDescTable, i64 0, i64 3), align 8, !tbaa !18
  %16 = icmp eq %struct.sfs_mem_filedesc_t* %15, null
  br i1 %16, label %4, label %17

17:                                               ; preds = %14
  %18 = load %struct.sfs_mem_filedesc_t*, %struct.sfs_mem_filedesc_t** getelementptr inbounds ([32 x %struct.sfs_mem_filedesc_t*], [32 x %struct.sfs_mem_filedesc_t*]* @openFileDescTable, i64 0, i64 4), align 16, !tbaa !18
  %19 = icmp eq %struct.sfs_mem_filedesc_t* %18, null
  br i1 %19, label %4, label %20

20:                                               ; preds = %17
  %21 = load %struct.sfs_mem_filedesc_t*, %struct.sfs_mem_filedesc_t** getelementptr inbounds ([32 x %struct.sfs_mem_filedesc_t*], [32 x %struct.sfs_mem_filedesc_t*]* @openFileDescTable, i64 0, i64 5), align 8, !tbaa !18
  %22 = icmp eq %struct.sfs_mem_filedesc_t* %21, null
  br i1 %22, label %4, label %23

23:                                               ; preds = %20
  %24 = load %struct.sfs_mem_filedesc_t*, %struct.sfs_mem_filedesc_t** getelementptr inbounds ([32 x %struct.sfs_mem_filedesc_t*], [32 x %struct.sfs_mem_filedesc_t*]* @openFileDescTable, i64 0, i64 6), align 16, !tbaa !18
  %25 = icmp eq %struct.sfs_mem_filedesc_t* %24, null
  br i1 %25, label %4, label %26

26:                                               ; preds = %23
  %27 = load %struct.sfs_mem_filedesc_t*, %struct.sfs_mem_filedesc_t** getelementptr inbounds ([32 x %struct.sfs_mem_filedesc_t*], [32 x %struct.sfs_mem_filedesc_t*]* @openFileDescTable, i64 0, i64 7), align 8, !tbaa !18
  %28 = icmp eq %struct.sfs_mem_filedesc_t* %27, null
  br i1 %28, label %4, label %29

29:                                               ; preds = %26
  %30 = load %struct.sfs_mem_filedesc_t*, %struct.sfs_mem_filedesc_t** getelementptr inbounds ([32 x %struct.sfs_mem_filedesc_t*], [32 x %struct.sfs_mem_filedesc_t*]* @openFileDescTable, i64 0, i64 8), align 16, !tbaa !18
  %31 = icmp eq %struct.sfs_mem_filedesc_t* %30, null
  br i1 %31, label %4, label %32

32:                                               ; preds = %29
  %33 = load %struct.sfs_mem_filedesc_t*, %struct.sfs_mem_filedesc_t** getelementptr inbounds ([32 x %struct.sfs_mem_filedesc_t*], [32 x %struct.sfs_mem_filedesc_t*]* @openFileDescTable, i64 0, i64 9), align 8, !tbaa !18
  %34 = icmp eq %struct.sfs_mem_filedesc_t* %33, null
  br i1 %34, label %4, label %35

35:                                               ; preds = %32
  %36 = load %struct.sfs_mem_filedesc_t*, %struct.sfs_mem_filedesc_t** getelementptr inbounds ([32 x %struct.sfs_mem_filedesc_t*], [32 x %struct.sfs_mem_filedesc_t*]* @openFileDescTable, i64 0, i64 10), align 16, !tbaa !18
  %37 = icmp eq %struct.sfs_mem_filedesc_t* %36, null
  br i1 %37, label %4, label %38

38:                                               ; preds = %35
  %39 = load %struct.sfs_mem_filedesc_t*, %struct.sfs_mem_filedesc_t** getelementptr inbounds ([32 x %struct.sfs_mem_filedesc_t*], [32 x %struct.sfs_mem_filedesc_t*]* @openFileDescTable, i64 0, i64 11), align 8, !tbaa !18
  %40 = icmp eq %struct.sfs_mem_filedesc_t* %39, null
  br i1 %40, label %4, label %41

41:                                               ; preds = %38
  %42 = load %struct.sfs_mem_filedesc_t*, %struct.sfs_mem_filedesc_t** getelementptr inbounds ([32 x %struct.sfs_mem_filedesc_t*], [32 x %struct.sfs_mem_filedesc_t*]* @openFileDescTable, i64 0, i64 12), align 16, !tbaa !18
  %43 = icmp eq %struct.sfs_mem_filedesc_t* %42, null
  br i1 %43, label %4, label %44

44:                                               ; preds = %41
  %45 = load %struct.sfs_mem_filedesc_t*, %struct.sfs_mem_filedesc_t** getelementptr inbounds ([32 x %struct.sfs_mem_filedesc_t*], [32 x %struct.sfs_mem_filedesc_t*]* @openFileDescTable, i64 0, i64 13), align 8, !tbaa !18
  %46 = icmp eq %struct.sfs_mem_filedesc_t* %45, null
  br i1 %46, label %4, label %47

47:                                               ; preds = %44
  %48 = load %struct.sfs_mem_filedesc_t*, %struct.sfs_mem_filedesc_t** getelementptr inbounds ([32 x %struct.sfs_mem_filedesc_t*], [32 x %struct.sfs_mem_filedesc_t*]* @openFileDescTable, i64 0, i64 14), align 16, !tbaa !18
  %49 = icmp eq %struct.sfs_mem_filedesc_t* %48, null
  br i1 %49, label %4, label %50

50:                                               ; preds = %47
  %51 = load %struct.sfs_mem_filedesc_t*, %struct.sfs_mem_filedesc_t** getelementptr inbounds ([32 x %struct.sfs_mem_filedesc_t*], [32 x %struct.sfs_mem_filedesc_t*]* @openFileDescTable, i64 0, i64 15), align 8, !tbaa !18
  %52 = icmp eq %struct.sfs_mem_filedesc_t* %51, null
  br i1 %52, label %4, label %53

53:                                               ; preds = %50
  %54 = load %struct.sfs_mem_filedesc_t*, %struct.sfs_mem_filedesc_t** getelementptr inbounds ([32 x %struct.sfs_mem_filedesc_t*], [32 x %struct.sfs_mem_filedesc_t*]* @openFileDescTable, i64 0, i64 16), align 16, !tbaa !18
  %55 = icmp eq %struct.sfs_mem_filedesc_t* %54, null
  br i1 %55, label %4, label %56

56:                                               ; preds = %53
  %57 = load %struct.sfs_mem_filedesc_t*, %struct.sfs_mem_filedesc_t** getelementptr inbounds ([32 x %struct.sfs_mem_filedesc_t*], [32 x %struct.sfs_mem_filedesc_t*]* @openFileDescTable, i64 0, i64 17), align 8, !tbaa !18
  %58 = icmp eq %struct.sfs_mem_filedesc_t* %57, null
  br i1 %58, label %4, label %59

59:                                               ; preds = %56
  %60 = load %struct.sfs_mem_filedesc_t*, %struct.sfs_mem_filedesc_t** getelementptr inbounds ([32 x %struct.sfs_mem_filedesc_t*], [32 x %struct.sfs_mem_filedesc_t*]* @openFileDescTable, i64 0, i64 18), align 16, !tbaa !18
  %61 = icmp eq %struct.sfs_mem_filedesc_t* %60, null
  br i1 %61, label %4, label %62

62:                                               ; preds = %59
  %63 = load %struct.sfs_mem_filedesc_t*, %struct.sfs_mem_filedesc_t** getelementptr inbounds ([32 x %struct.sfs_mem_filedesc_t*], [32 x %struct.sfs_mem_filedesc_t*]* @openFileDescTable, i64 0, i64 19), align 8, !tbaa !18
  %64 = icmp eq %struct.sfs_mem_filedesc_t* %63, null
  br i1 %64, label %4, label %65

65:                                               ; preds = %62
  %66 = load %struct.sfs_mem_filedesc_t*, %struct.sfs_mem_filedesc_t** getelementptr inbounds ([32 x %struct.sfs_mem_filedesc_t*], [32 x %struct.sfs_mem_filedesc_t*]* @openFileDescTable, i64 0, i64 20), align 16, !tbaa !18
  %67 = icmp eq %struct.sfs_mem_filedesc_t* %66, null
  br i1 %67, label %4, label %68

68:                                               ; preds = %65
  %69 = load %struct.sfs_mem_filedesc_t*, %struct.sfs_mem_filedesc_t** getelementptr inbounds ([32 x %struct.sfs_mem_filedesc_t*], [32 x %struct.sfs_mem_filedesc_t*]* @openFileDescTable, i64 0, i64 21), align 8, !tbaa !18
  %70 = icmp eq %struct.sfs_mem_filedesc_t* %69, null
  br i1 %70, label %4, label %71

71:                                               ; preds = %68
  %72 = load %struct.sfs_mem_filedesc_t*, %struct.sfs_mem_filedesc_t** getelementptr inbounds ([32 x %struct.sfs_mem_filedesc_t*], [32 x %struct.sfs_mem_filedesc_t*]* @openFileDescTable, i64 0, i64 22), align 16, !tbaa !18
  %73 = icmp eq %struct.sfs_mem_filedesc_t* %72, null
  br i1 %73, label %4, label %74

74:                                               ; preds = %71
  %75 = load %struct.sfs_mem_filedesc_t*, %struct.sfs_mem_filedesc_t** getelementptr inbounds ([32 x %struct.sfs_mem_filedesc_t*], [32 x %struct.sfs_mem_filedesc_t*]* @openFileDescTable, i64 0, i64 23), align 8, !tbaa !18
  %76 = icmp eq %struct.sfs_mem_filedesc_t* %75, null
  br i1 %76, label %4, label %77

77:                                               ; preds = %74
  %78 = load %struct.sfs_mem_filedesc_t*, %struct.sfs_mem_filedesc_t** getelementptr inbounds ([32 x %struct.sfs_mem_filedesc_t*], [32 x %struct.sfs_mem_filedesc_t*]* @openFileDescTable, i64 0, i64 24), align 16, !tbaa !18
  %79 = icmp eq %struct.sfs_mem_filedesc_t* %78, null
  br i1 %79, label %4, label %80

80:                                               ; preds = %77
  %81 = load %struct.sfs_mem_filedesc_t*, %struct.sfs_mem_filedesc_t** getelementptr inbounds ([32 x %struct.sfs_mem_filedesc_t*], [32 x %struct.sfs_mem_filedesc_t*]* @openFileDescTable, i64 0, i64 25), align 8, !tbaa !18
  %82 = icmp eq %struct.sfs_mem_filedesc_t* %81, null
  br i1 %82, label %4, label %83

83:                                               ; preds = %80
  %84 = load %struct.sfs_mem_filedesc_t*, %struct.sfs_mem_filedesc_t** getelementptr inbounds ([32 x %struct.sfs_mem_filedesc_t*], [32 x %struct.sfs_mem_filedesc_t*]* @openFileDescTable, i64 0, i64 26), align 16, !tbaa !18
  %85 = icmp eq %struct.sfs_mem_filedesc_t* %84, null
  br i1 %85, label %4, label %86

86:                                               ; preds = %83
  %87 = load %struct.sfs_mem_filedesc_t*, %struct.sfs_mem_filedesc_t** getelementptr inbounds ([32 x %struct.sfs_mem_filedesc_t*], [32 x %struct.sfs_mem_filedesc_t*]* @openFileDescTable, i64 0, i64 27), align 8, !tbaa !18
  %88 = icmp eq %struct.sfs_mem_filedesc_t* %87, null
  br i1 %88, label %4, label %89

89:                                               ; preds = %86
  %90 = load %struct.sfs_mem_filedesc_t*, %struct.sfs_mem_filedesc_t** getelementptr inbounds ([32 x %struct.sfs_mem_filedesc_t*], [32 x %struct.sfs_mem_filedesc_t*]* @openFileDescTable, i64 0, i64 28), align 16, !tbaa !18
  %91 = icmp eq %struct.sfs_mem_filedesc_t* %90, null
  br i1 %91, label %4, label %92

92:                                               ; preds = %89
  %93 = load %struct.sfs_mem_filedesc_t*, %struct.sfs_mem_filedesc_t** getelementptr inbounds ([32 x %struct.sfs_mem_filedesc_t*], [32 x %struct.sfs_mem_filedesc_t*]* @openFileDescTable, i64 0, i64 29), align 8, !tbaa !18
  %94 = icmp eq %struct.sfs_mem_filedesc_t* %93, null
  br i1 %94, label %4, label %95

95:                                               ; preds = %92
  %96 = load %struct.sfs_mem_filedesc_t*, %struct.sfs_mem_filedesc_t** getelementptr inbounds ([32 x %struct.sfs_mem_filedesc_t*], [32 x %struct.sfs_mem_filedesc_t*]* @openFileDescTable, i64 0, i64 30), align 16, !tbaa !18
  %97 = icmp eq %struct.sfs_mem_filedesc_t* %96, null
  br i1 %97, label %4, label %98

98:                                               ; preds = %95
  %99 = load %struct.sfs_mem_filedesc_t*, %struct.sfs_mem_filedesc_t** getelementptr inbounds ([32 x %struct.sfs_mem_filedesc_t*], [32 x %struct.sfs_mem_filedesc_t*]* @openFileDescTable, i64 0, i64 31), align 8, !tbaa !18
  %100 = icmp eq %struct.sfs_mem_filedesc_t* %99, null
  br i1 %100, label %4, label %139

101:                                              ; preds = %4
  %102 = bitcast i8* %6 to %struct.sfs_mem_filedesc_t*
  %103 = sext i32 %0 to i64
  %104 = getelementptr inbounds [15 x %struct.sfs_mem_file_t*], [15 x %struct.sfs_mem_file_t*]* @openFileTable, i64 0, i64 %103
  %105 = load %struct.sfs_mem_file_t*, %struct.sfs_mem_file_t** %104, align 8, !tbaa !18
  %106 = icmp eq %struct.sfs_mem_file_t* %105, null
  br i1 %106, label %113, label %107

107:                                              ; preds = %101
  %108 = getelementptr inbounds %struct.sfs_mem_file_t, %struct.sfs_mem_file_t* %105, i64 0, i32 0
  %109 = load i32, i32* %108, align 8, !tbaa !20
  %110 = getelementptr inbounds %struct.sfs_mem_file_t, %struct.sfs_mem_file_t* %105, i64 0, i32 2
  %111 = load %struct.sfs_dir_entry_t*, %struct.sfs_dir_entry_t** %110, align 8, !tbaa !22
  %112 = add i32 %109, 1
  br label %125

113:                                              ; preds = %101
  %114 = tail call noalias dereferenceable_or_null(16) i8* @malloc(i64 noundef 16) #15
  %115 = bitcast i8* %114 to %struct.sfs_mem_file_t*
  %116 = icmp eq i8* %114, null
  br i1 %116, label %117, label %118

117:                                              ; preds = %113
  tail call void @free(i8* noundef nonnull %6) #15
  br label %139

118:                                              ; preds = %113
  %119 = tail call %struct.sfs_filesystem_t* @accessSuperBlock() #15
  %120 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %119, i64 0, i32 5, i64 %103
  %121 = getelementptr inbounds %struct.sfs_mem_file_t, %struct.sfs_mem_file_t* %115, i64 0, i32 2
  store %struct.sfs_dir_entry_t* %120, %struct.sfs_dir_entry_t** %121, align 8, !tbaa !22
  %122 = getelementptr inbounds %struct.sfs_mem_file_t, %struct.sfs_mem_file_t* %115, i64 0, i32 1
  store i32 %0, i32* %122, align 4, !tbaa !23
  %123 = getelementptr inbounds %struct.sfs_mem_file_t, %struct.sfs_mem_file_t* %115, i64 0, i32 0
  store i32 0, i32* %123, align 8, !tbaa !20
  %124 = bitcast %struct.sfs_mem_file_t** %104 to i8**
  store i8* %114, i8** %124, align 8, !tbaa !18
  br label %125

125:                                              ; preds = %107, %118
  %126 = phi %struct.sfs_dir_entry_t* [ %120, %118 ], [ %111, %107 ]
  %127 = phi i32 [ 1, %118 ], [ %112, %107 ]
  %128 = phi %struct.sfs_mem_file_t* [ %115, %118 ], [ %105, %107 ]
  %129 = getelementptr inbounds %struct.sfs_mem_file_t, %struct.sfs_mem_file_t* %128, i64 0, i32 0
  store i32 %127, i32* %129, align 8, !tbaa !20
  %130 = getelementptr inbounds %struct.sfs_mem_filedesc_t, %struct.sfs_mem_filedesc_t* %102, i64 0, i32 0
  store %struct.sfs_mem_file_t* %128, %struct.sfs_mem_file_t** %130, align 8, !tbaa !24
  %131 = getelementptr inbounds %struct.sfs_dir_entry_t, %struct.sfs_dir_entry_t* %126, i64 0, i32 0
  %132 = load i32, i32* %131, align 4, !tbaa !5
  %133 = getelementptr inbounds %struct.sfs_mem_filedesc_t, %struct.sfs_mem_filedesc_t* %102, i64 0, i32 1
  store i32 %132, i32* %133, align 8, !tbaa !27
  %134 = getelementptr inbounds %struct.sfs_mem_filedesc_t, %struct.sfs_mem_filedesc_t* %102, i64 0, i32 2
  store i32 %132, i32* %134, align 4, !tbaa !28
  %135 = getelementptr inbounds %struct.sfs_mem_filedesc_t, %struct.sfs_mem_filedesc_t* %102, i64 0, i32 3
  store i64 0, i64* %135, align 8, !tbaa !29
  %136 = zext i32 %5 to i64
  %137 = getelementptr inbounds [32 x %struct.sfs_mem_filedesc_t*], [32 x %struct.sfs_mem_filedesc_t*]* @openFileDescTable, i64 0, i64 %136
  %138 = bitcast %struct.sfs_mem_filedesc_t** %137 to i8**
  store i8* %6, i8** %138, align 8, !tbaa !18
  br label %139

139:                                              ; preds = %98, %4, %117, %125
  %140 = phi i32 [ -12, %117 ], [ %5, %125 ], [ -12, %4 ], [ -24, %98 ]
  ret i32 %140
}

; Function Attrs: mustprogress nounwind uwtable willreturn
define dso_local void @sfs_close(i32 noundef %0) local_unnamed_addr #3 {
  %2 = icmp ugt i32 %0, 32
  br i1 %2, label %22, label %3

3:                                                ; preds = %1
  %4 = zext i32 %0 to i64
  %5 = getelementptr inbounds [32 x %struct.sfs_mem_filedesc_t*], [32 x %struct.sfs_mem_filedesc_t*]* @openFileDescTable, i64 0, i64 %4
  %6 = load %struct.sfs_mem_filedesc_t*, %struct.sfs_mem_filedesc_t** %5, align 8, !tbaa !18
  %7 = icmp eq %struct.sfs_mem_filedesc_t* %6, null
  br i1 %7, label %22, label %8

8:                                                ; preds = %3
  %9 = getelementptr inbounds %struct.sfs_mem_filedesc_t, %struct.sfs_mem_filedesc_t* %6, i64 0, i32 0
  %10 = load %struct.sfs_mem_file_t*, %struct.sfs_mem_file_t** %9, align 8, !tbaa !24
  store %struct.sfs_mem_filedesc_t* null, %struct.sfs_mem_filedesc_t** %5, align 8, !tbaa !18
  %11 = bitcast %struct.sfs_mem_filedesc_t* %6 to i8*
  tail call void @free(i8* noundef %11) #15
  %12 = getelementptr inbounds %struct.sfs_mem_file_t, %struct.sfs_mem_file_t* %10, i64 0, i32 0
  %13 = load i32, i32* %12, align 8, !tbaa !20
  %14 = add i32 %13, -1
  store i32 %14, i32* %12, align 8, !tbaa !20
  %15 = icmp eq i32 %14, 0
  br i1 %15, label %16, label %22

16:                                               ; preds = %8
  %17 = getelementptr inbounds %struct.sfs_mem_file_t, %struct.sfs_mem_file_t* %10, i64 0, i32 1
  %18 = load i32, i32* %17, align 4, !tbaa !23
  %19 = bitcast %struct.sfs_mem_file_t* %10 to i8*
  tail call void @free(i8* noundef %19) #15
  %20 = sext i32 %18 to i64
  %21 = getelementptr inbounds [15 x %struct.sfs_mem_file_t*], [15 x %struct.sfs_mem_file_t*]* @openFileTable, i64 0, i64 %20
  store %struct.sfs_mem_file_t* null, %struct.sfs_mem_file_t** %21, align 8, !tbaa !18
  br label %22

22:                                               ; preds = %3, %8, %16, %1
  ret void
}

; Function Attrs: inaccessiblemem_or_argmemonly mustprogress nounwind willreturn
declare void @free(i8* nocapture noundef) local_unnamed_addr #4

; Function Attrs: nounwind uwtable
define dso_local i64 @sfs_read(i32 noundef %0, i8* nocapture noundef writeonly %1, i64 noundef %2) local_unnamed_addr #0 {
  %4 = icmp ugt i32 %0, 32
  br i1 %4, label %69, label %5

5:                                                ; preds = %3
  %6 = tail call i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef nonnull @sfs_mutexes) #15
  %7 = zext i32 %0 to i64
  %8 = getelementptr inbounds [32 x %struct.sfs_mem_filedesc_t*], [32 x %struct.sfs_mem_filedesc_t*]* @openFileDescTable, i64 0, i64 %7
  %9 = load %struct.sfs_mem_filedesc_t*, %struct.sfs_mem_filedesc_t** %8, align 8, !tbaa !18
  %10 = icmp eq %struct.sfs_mem_filedesc_t* %9, null
  br i1 %10, label %66, label %11

11:                                               ; preds = %5
  %12 = getelementptr inbounds %struct.sfs_mem_filedesc_t, %struct.sfs_mem_filedesc_t* %9, i64 0, i32 0
  %13 = load %struct.sfs_mem_file_t*, %struct.sfs_mem_file_t** %12, align 8, !tbaa !24
  %14 = getelementptr inbounds %struct.sfs_mem_file_t, %struct.sfs_mem_file_t* %13, i64 0, i32 2
  %15 = load %struct.sfs_dir_entry_t*, %struct.sfs_dir_entry_t** %14, align 8, !tbaa !22
  %16 = getelementptr inbounds %struct.sfs_dir_entry_t, %struct.sfs_dir_entry_t* %15, i64 0, i32 1
  %17 = load i32, i32* %16, align 4, !tbaa !17
  %18 = zext i32 %17 to i64
  %19 = getelementptr inbounds %struct.sfs_mem_filedesc_t, %struct.sfs_mem_filedesc_t* %9, i64 0, i32 3
  %20 = load i64, i64* %19, align 8, !tbaa !29
  %21 = icmp ugt i64 %20, %18
  br i1 %21, label %22, label %23

22:                                               ; preds = %11
  tail call void @__assert_fail(i8* noundef getelementptr inbounds ([20 x i8], [20 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str.1, i64 0, i64 0), i32 noundef 368, i8* noundef getelementptr inbounds ([38 x i8], [38 x i8]* @__PRETTY_FUNCTION__.sfs_read, i64 0, i64 0)) #16
  unreachable

23:                                               ; preds = %11
  %24 = sub i64 %18, %20
  %25 = icmp ult i64 %24, %2
  %26 = select i1 %25, i64 %24, i64 %2
  %27 = getelementptr inbounds %struct.sfs_mem_filedesc_t, %struct.sfs_mem_filedesc_t* %9, i64 0, i32 2
  %28 = load i32, i32* %27, align 4, !tbaa !28
  %29 = tail call %struct.sfs_block_file_t* @accessFileBlock(i32 noundef %28) #15
  %30 = urem i64 %20, 500
  %31 = icmp eq i64 %20, 0
  %32 = add i64 %20, 499
  %33 = urem i64 %32, 500
  %34 = sub i64 %32, %33
  %35 = select i1 %31, i64 500, i64 %34
  %36 = sub i64 %35, %20
  %37 = icmp ult i64 %36, %26
  %38 = select i1 %37, i64 %36, i64 %26
  br label %39

39:                                               ; preds = %54, %23
  %40 = phi i8* [ %1, %23 ], [ %51, %54 ]
  %41 = phi i64 [ %26, %23 ], [ %52, %54 ]
  %42 = phi %struct.sfs_block_file_t* [ %29, %23 ], [ %59, %54 ]
  %43 = phi i64 [ %30, %23 ], [ 0, %54 ]
  %44 = phi i64 [ %38, %23 ], [ %56, %54 ]
  %45 = icmp eq i64 %44, 0
  br i1 %45, label %50, label %46

46:                                               ; preds = %39
  %47 = getelementptr inbounds %struct.sfs_block_file_t, %struct.sfs_block_file_t* %42, i64 0, i32 1, i64 %43
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %40, i8* nonnull align 1 %47, i64 %44, i1 false)
  %48 = getelementptr inbounds i8, i8* %40, i64 %44
  %49 = sub i64 %41, %44
  br label %50

50:                                               ; preds = %46, %39
  %51 = phi i8* [ %48, %46 ], [ %40, %39 ]
  %52 = phi i64 [ %49, %46 ], [ %41, %39 ]
  %53 = icmp eq i64 %52, 0
  br i1 %53, label %62, label %54

54:                                               ; preds = %50
  %55 = icmp ult i64 %52, 500
  %56 = select i1 %55, i64 %52, i64 500
  %57 = getelementptr inbounds %struct.sfs_block_file_t, %struct.sfs_block_file_t* %42, i64 0, i32 0, i32 2
  %58 = load i32, i32* %57, align 4, !tbaa !30
  %59 = tail call %struct.sfs_block_file_t* @accessFileBlock(i32 noundef %58) #15
  %60 = icmp eq %struct.sfs_block_file_t* %59, null
  br i1 %60, label %61, label %39

61:                                               ; preds = %54
  tail call void @__assert_fail(i8* noundef getelementptr inbounds ([18 x i8], [18 x i8]* @.str.2, i64 0, i64 0), i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str.1, i64 0, i64 0), i32 noundef 408, i8* noundef getelementptr inbounds ([38 x i8], [38 x i8]* @__PRETTY_FUNCTION__.sfs_read, i64 0, i64 0)) #16
  unreachable

62:                                               ; preds = %50
  %63 = getelementptr inbounds %struct.sfs_block_file_t, %struct.sfs_block_file_t* %42, i64 0, i32 0
  %64 = tail call i32 @idOfBlock(%struct.sfs_block_hdr_t* noundef %63) #15
  store i32 %64, i32* %27, align 4, !tbaa !28
  %65 = add i64 %26, %20
  store i64 %65, i64* %19, align 8, !tbaa !29
  br label %66

66:                                               ; preds = %5, %62
  %67 = phi i64 [ %26, %62 ], [ -9, %5 ]
  %68 = tail call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef nonnull @sfs_mutexes) #15
  br label %69

69:                                               ; preds = %66, %3
  %70 = phi i64 [ -9, %3 ], [ %67, %66 ]
  ret i64 %70
}

; Function Attrs: nounwind
declare i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef) local_unnamed_addr #5

; Function Attrs: nounwind
declare i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef) local_unnamed_addr #5

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) local_unnamed_addr #6

declare %struct.sfs_block_file_t* @accessFileBlock(i32 noundef) local_unnamed_addr #2

; Function Attrs: argmemonly mustprogress nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #7

declare i32 @idOfBlock(%struct.sfs_block_hdr_t* noundef) local_unnamed_addr #2

; Function Attrs: nounwind uwtable
define dso_local i64 @sfs_write(i32 noundef %0, i8* nocapture noundef readonly %1, i64 noundef %2) local_unnamed_addr #0 {
  %4 = icmp ugt i32 %0, 32
  br i1 %4, label %144, label %5

5:                                                ; preds = %3
  %6 = tail call i32 @pthread_mutex_lock(%union.pthread_mutex_t* noundef nonnull @sfs_mutexes) #15
  %7 = zext i32 %0 to i64
  %8 = getelementptr inbounds [32 x %struct.sfs_mem_filedesc_t*], [32 x %struct.sfs_mem_filedesc_t*]* @openFileDescTable, i64 0, i64 %7
  %9 = load %struct.sfs_mem_filedesc_t*, %struct.sfs_mem_filedesc_t** %8, align 8, !tbaa !18
  %10 = icmp eq %struct.sfs_mem_filedesc_t* %9, null
  br i1 %10, label %141, label %11

11:                                               ; preds = %5
  %12 = getelementptr inbounds %struct.sfs_mem_filedesc_t, %struct.sfs_mem_filedesc_t* %9, i64 0, i32 0
  %13 = load %struct.sfs_mem_file_t*, %struct.sfs_mem_file_t** %12, align 8, !tbaa !24
  %14 = getelementptr inbounds %struct.sfs_mem_file_t, %struct.sfs_mem_file_t* %13, i64 0, i32 2
  %15 = load %struct.sfs_dir_entry_t*, %struct.sfs_dir_entry_t** %14, align 8, !tbaa !22
  %16 = getelementptr inbounds %struct.sfs_dir_entry_t, %struct.sfs_dir_entry_t* %15, i64 0, i32 1
  %17 = load i32, i32* %16, align 4, !tbaa !17
  %18 = zext i32 %17 to i64
  %19 = getelementptr inbounds %struct.sfs_mem_filedesc_t, %struct.sfs_mem_filedesc_t* %9, i64 0, i32 3
  %20 = load i64, i64* %19, align 8, !tbaa !29
  %21 = icmp ugt i64 %20, %18
  br i1 %21, label %22, label %23

22:                                               ; preds = %11
  tail call void @__assert_fail(i8* noundef getelementptr inbounds ([20 x i8], [20 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str.1, i64 0, i64 0), i32 noundef 437, i8* noundef getelementptr inbounds ([45 x i8], [45 x i8]* @__PRETTY_FUNCTION__.sfs_write, i64 0, i64 0)) #16
  unreachable

23:                                               ; preds = %11
  %24 = icmp eq i32 %17, 0
  %25 = add nuw nsw i64 %18, 499
  %26 = urem i64 %25, 500
  %27 = sub nuw nsw i64 %25, %26
  %28 = select i1 %24, i64 500, i64 %27
  %29 = add i64 %20, %2
  %30 = icmp ugt i64 %29, %28
  br i1 %30, label %31, label %76

31:                                               ; preds = %23
  %32 = add i64 %29, 499
  %33 = urem i64 %32, 500
  %34 = sub i64 %32, %33
  %35 = icmp ugt i64 %34, 4294967295
  br i1 %35, label %141, label %36

36:                                               ; preds = %31
  %37 = sub nsw i64 %34, %28
  %38 = udiv i64 %37, 500
  %39 = trunc i64 %38 to i32
  %40 = icmp eq i32 %39, 0
  br i1 %40, label %41, label %42

41:                                               ; preds = %36
  tail call void @__assert_fail(i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @.str.3, i64 0, i64 0), i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str.1, i64 0, i64 0), i32 noundef 465, i8* noundef getelementptr inbounds ([45 x i8], [45 x i8]* @__PRETTY_FUNCTION__.sfs_write, i64 0, i64 0)) #16
  unreachable

42:                                               ; preds = %36
  %43 = tail call %struct.sfs_filesystem_t* @accessSuperBlock() #15
  %44 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %43, i64 0, i32 2
  %45 = load i32, i32* %44, align 4, !tbaa !10
  %46 = icmp eq i32 %45, 0
  br i1 %46, label %141, label %47

47:                                               ; preds = %42
  %48 = tail call %struct.sfs_block_hdr_t* @accessFreeBlock(i32 noundef %45) #15
  %49 = icmp ugt i32 %39, 1
  br i1 %49, label %50, label %60

50:                                               ; preds = %47, %56
  %51 = phi i32 [ %58, %56 ], [ 1, %47 ]
  %52 = phi %struct.sfs_block_hdr_t* [ %57, %56 ], [ %48, %47 ]
  %53 = getelementptr inbounds %struct.sfs_block_hdr_t, %struct.sfs_block_hdr_t* %52, i64 0, i32 2
  %54 = load i32, i32* %53, align 4, !tbaa !12
  %55 = icmp eq i32 %54, 0
  br i1 %55, label %141, label %56

56:                                               ; preds = %50
  %57 = tail call %struct.sfs_block_hdr_t* @accessFreeBlock(i32 noundef %54) #15
  %58 = add nuw i32 %51, 1
  %59 = icmp eq i32 %58, %39
  br i1 %59, label %60, label %50, !llvm.loop !32

60:                                               ; preds = %56, %47
  %61 = phi %struct.sfs_block_hdr_t* [ %48, %47 ], [ %57, %56 ]
  %62 = getelementptr inbounds %struct.sfs_block_hdr_t, %struct.sfs_block_hdr_t* %61, i64 0, i32 2
  %63 = load i32, i32* %62, align 4, !tbaa !12
  %64 = icmp eq i32 %63, 0
  br i1 %64, label %68, label %65

65:                                               ; preds = %60
  %66 = tail call %struct.sfs_block_hdr_t* @accessFreeBlock(i32 noundef %63) #15
  %67 = getelementptr inbounds %struct.sfs_block_hdr_t, %struct.sfs_block_hdr_t* %66, i64 0, i32 1
  store i32 0, i32* %67, align 4, !tbaa !14
  store i32 0, i32* %62, align 4, !tbaa !12
  br label %68

68:                                               ; preds = %65, %60
  store i32 %63, i32* %44, align 4, !tbaa !10
  %69 = icmp eq %struct.sfs_block_hdr_t* %48, null
  br i1 %69, label %76, label %70

70:                                               ; preds = %68, %70
  %71 = phi %struct.sfs_block_hdr_t* [ %74, %70 ], [ %48, %68 ]
  tail call void @setBlockType(%struct.sfs_block_hdr_t* noundef nonnull %71, i8* noundef getelementptr inbounds ([5 x i8], [5 x i8]* @.str.4, i64 0, i64 0)) #15
  %72 = getelementptr inbounds %struct.sfs_block_hdr_t, %struct.sfs_block_hdr_t* %71, i64 0, i32 2
  %73 = load i32, i32* %72, align 4, !tbaa !12
  %74 = tail call %struct.sfs_block_hdr_t* @accessFreeBlock(i32 noundef %73) #15
  %75 = icmp eq %struct.sfs_block_hdr_t* %74, null
  br i1 %75, label %76, label %70, !llvm.loop !15

76:                                               ; preds = %70, %68, %23
  %77 = phi i32 [ 0, %23 ], [ %45, %68 ], [ %45, %70 ]
  %78 = getelementptr inbounds %struct.sfs_mem_filedesc_t, %struct.sfs_mem_filedesc_t* %9, i64 0, i32 2
  %79 = load i32, i32* %78, align 4, !tbaa !28
  %80 = tail call %struct.sfs_block_file_t* @accessFileBlock(i32 noundef %79) #15
  %81 = urem i64 %20, 500
  %82 = icmp eq i64 %20, 0
  %83 = add i64 %20, 499
  %84 = urem i64 %83, 500
  %85 = sub i64 %83, %84
  %86 = select i1 %82, i64 500, i64 %85
  %87 = sub i64 %86, %20
  %88 = icmp ult i64 %87, %2
  %89 = select i1 %88, i64 %87, i64 %2
  br label %90

90:                                               ; preds = %124, %76
  %91 = phi i64 [ %109, %124 ], [ %2, %76 ]
  %92 = phi i32 [ 0, %124 ], [ %77, %76 ]
  %93 = phi i8* [ %110, %124 ], [ %1, %76 ]
  %94 = phi %struct.sfs_block_file_t* [ %125, %124 ], [ %80, %76 ]
  %95 = phi i64 [ 0, %124 ], [ %81, %76 ]
  %96 = phi i64 [ %114, %124 ], [ %89, %76 ]
  br label %97

97:                                               ; preds = %90, %112
  %98 = phi i64 [ %109, %112 ], [ %91, %90 ]
  %99 = phi i8* [ %110, %112 ], [ %93, %90 ]
  %100 = phi %struct.sfs_block_file_t* [ %117, %112 ], [ %94, %90 ]
  %101 = phi i64 [ 0, %112 ], [ %95, %90 ]
  %102 = phi i64 [ %114, %112 ], [ %96, %90 ]
  %103 = icmp eq i64 %102, 0
  br i1 %103, label %108, label %104

104:                                              ; preds = %97
  %105 = getelementptr inbounds %struct.sfs_block_file_t, %struct.sfs_block_file_t* %100, i64 0, i32 1, i64 %101
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 %105, i8* align 1 %99, i64 %102, i1 false)
  %106 = getelementptr inbounds i8, i8* %99, i64 %102
  %107 = sub i64 %98, %102
  br label %108

108:                                              ; preds = %104, %97
  %109 = phi i64 [ %107, %104 ], [ %98, %97 ]
  %110 = phi i8* [ %106, %104 ], [ %99, %97 ]
  %111 = icmp eq i64 %109, 0
  br i1 %111, label %128, label %112

112:                                              ; preds = %108
  %113 = icmp ult i64 %109, 500
  %114 = select i1 %113, i64 %109, i64 500
  %115 = getelementptr inbounds %struct.sfs_block_file_t, %struct.sfs_block_file_t* %100, i64 0, i32 0, i32 2
  %116 = load i32, i32* %115, align 4, !tbaa !30
  %117 = tail call %struct.sfs_block_file_t* @accessFileBlock(i32 noundef %116) #15
  %118 = icmp eq %struct.sfs_block_file_t* %117, null
  br i1 %118, label %119, label %97

119:                                              ; preds = %112
  %120 = getelementptr inbounds %struct.sfs_block_file_t, %struct.sfs_block_file_t* %100, i64 0, i32 0
  %121 = getelementptr inbounds %struct.sfs_block_file_t, %struct.sfs_block_file_t* %100, i64 0, i32 0, i32 2
  %122 = icmp eq i32 %92, 0
  br i1 %122, label %123, label %124

123:                                              ; preds = %119
  tail call void @__assert_fail(i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @.str.5, i64 0, i64 0), i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str.1, i64 0, i64 0), i32 noundef 501, i8* noundef getelementptr inbounds ([45 x i8], [45 x i8]* @__PRETTY_FUNCTION__.sfs_write, i64 0, i64 0)) #16
  unreachable

124:                                              ; preds = %119
  %125 = tail call %struct.sfs_block_file_t* @accessFileBlock(i32 noundef %92) #15
  store i32 %92, i32* %121, align 4, !tbaa !30
  %126 = tail call i32 @idOfBlock(%struct.sfs_block_hdr_t* noundef nonnull %120) #15
  %127 = getelementptr inbounds %struct.sfs_block_file_t, %struct.sfs_block_file_t* %125, i64 0, i32 0, i32 1
  store i32 %126, i32* %127, align 4, !tbaa !33
  br label %90

128:                                              ; preds = %108
  %129 = getelementptr inbounds %struct.sfs_block_file_t, %struct.sfs_block_file_t* %100, i64 0, i32 0
  %130 = tail call i32 @idOfBlock(%struct.sfs_block_hdr_t* noundef %129) #15
  store i32 %130, i32* %78, align 4, !tbaa !28
  store i64 %29, i64* %19, align 8, !tbaa !29
  %131 = icmp ugt i64 %29, %18
  br i1 %131, label %132, label %141

132:                                              ; preds = %128
  %133 = icmp ult i64 %29, 4294967295
  br i1 %133, label %135, label %134

134:                                              ; preds = %132
  tail call void @__assert_fail(i8* noundef getelementptr inbounds ([27 x i8], [27 x i8]* @.str.6, i64 0, i64 0), i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str.1, i64 0, i64 0), i32 noundef 518, i8* noundef getelementptr inbounds ([45 x i8], [45 x i8]* @__PRETTY_FUNCTION__.sfs_write, i64 0, i64 0)) #16
  unreachable

135:                                              ; preds = %132
  %136 = trunc i64 %29 to i32
  %137 = load %struct.sfs_mem_file_t*, %struct.sfs_mem_file_t** %12, align 8, !tbaa !24
  %138 = getelementptr inbounds %struct.sfs_mem_file_t, %struct.sfs_mem_file_t* %137, i64 0, i32 2
  %139 = load %struct.sfs_dir_entry_t*, %struct.sfs_dir_entry_t** %138, align 8, !tbaa !22
  %140 = getelementptr inbounds %struct.sfs_dir_entry_t, %struct.sfs_dir_entry_t* %139, i64 0, i32 1
  store i32 %136, i32* %140, align 4, !tbaa !17
  br label %141

141:                                              ; preds = %50, %128, %135, %42, %31, %5
  %142 = phi i64 [ -9, %5 ], [ -27, %31 ], [ -28, %42 ], [ %2, %135 ], [ %2, %128 ], [ -28, %50 ]
  %143 = tail call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* noundef nonnull @sfs_mutexes) #15
  br label %144

144:                                              ; preds = %141, %3
  %145 = phi i64 [ -9, %3 ], [ %142, %141 ]
  ret i64 %145
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind readonly uwtable willreturn
define dso_local i64 @sfs_getpos(i32 noundef %0) local_unnamed_addr #8 {
  %2 = icmp ugt i32 %0, 31
  br i1 %2, label %11, label %3

3:                                                ; preds = %1
  %4 = zext i32 %0 to i64
  %5 = getelementptr inbounds [32 x %struct.sfs_mem_filedesc_t*], [32 x %struct.sfs_mem_filedesc_t*]* @openFileDescTable, i64 0, i64 %4
  %6 = load %struct.sfs_mem_filedesc_t*, %struct.sfs_mem_filedesc_t** %5, align 8, !tbaa !18
  %7 = icmp eq %struct.sfs_mem_filedesc_t* %6, null
  br i1 %7, label %11, label %8

8:                                                ; preds = %3
  %9 = getelementptr inbounds %struct.sfs_mem_filedesc_t, %struct.sfs_mem_filedesc_t* %6, i64 0, i32 3
  %10 = load i64, i64* %9, align 8, !tbaa !29
  br label %11

11:                                               ; preds = %1, %3, %8
  %12 = phi i64 [ %10, %8 ], [ -9, %3 ], [ -9, %1 ]
  ret i64 %12
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind uwtable willreturn
define dso_local i64 @sfs_seek(i32 noundef %0, i64 noundef %1) local_unnamed_addr #9 {
  %3 = icmp ugt i32 %0, 31
  br i1 %3, label %24, label %4

4:                                                ; preds = %2
  %5 = zext i32 %0 to i64
  %6 = getelementptr inbounds [32 x %struct.sfs_mem_filedesc_t*], [32 x %struct.sfs_mem_filedesc_t*]* @openFileDescTable, i64 0, i64 %5
  %7 = load %struct.sfs_mem_filedesc_t*, %struct.sfs_mem_filedesc_t** %6, align 8, !tbaa !18
  %8 = icmp eq %struct.sfs_mem_filedesc_t* %7, null
  br i1 %8, label %24, label %9

9:                                                ; preds = %4
  %10 = getelementptr inbounds %struct.sfs_mem_filedesc_t, %struct.sfs_mem_filedesc_t* %7, i64 0, i32 3
  %11 = load i64, i64* %10, align 8, !tbaa !29
  %12 = getelementptr inbounds %struct.sfs_mem_filedesc_t, %struct.sfs_mem_filedesc_t* %7, i64 0, i32 0
  %13 = load %struct.sfs_mem_file_t*, %struct.sfs_mem_file_t** %12, align 8, !tbaa !24
  %14 = getelementptr inbounds %struct.sfs_mem_file_t, %struct.sfs_mem_file_t* %13, i64 0, i32 2
  %15 = load %struct.sfs_dir_entry_t*, %struct.sfs_dir_entry_t** %14, align 8, !tbaa !22
  %16 = getelementptr inbounds %struct.sfs_dir_entry_t, %struct.sfs_dir_entry_t* %15, i64 0, i32 1
  %17 = load i32, i32* %16, align 4, !tbaa !17
  %18 = zext i32 %17 to i64
  %19 = add nsw i64 %11, %1
  %20 = icmp sgt i64 %19, 0
  %21 = select i1 %20, i64 %19, i64 0
  %22 = icmp ugt i64 %21, %18
  %23 = select i1 %22, i64 %18, i64 %21
  store i64 %23, i64* %10, align 8, !tbaa !29
  br label %24

24:                                               ; preds = %2, %4, %9
  %25 = phi i64 [ %23, %9 ], [ -9, %4 ], [ -9, %2 ]
  ret i64 %25
}

; Function Attrs: nounwind uwtable
define dso_local i32 @sfs_remove(i8* nocapture noundef readonly %0) local_unnamed_addr #0 {
  %2 = tail call i64 @strlen(i8* noundef nonnull dereferenceable(1) %0) #14
  %3 = add i64 %2, -24
  %4 = icmp ult i64 %3, -25
  br i1 %4, label %164, label %5

5:                                                ; preds = %1
  %6 = tail call i32 @getSFSStatus() #15
  %7 = icmp slt i32 %6, 0
  br i1 %7, label %164, label %8

8:                                                ; preds = %5
  %9 = tail call %struct.sfs_filesystem_t* @accessSuperBlock() #15
  %10 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %9, i64 0, i32 5, i64 0, i32 0
  %11 = load i32, i32* %10, align 4, !tbaa !5
  %12 = icmp eq i32 %11, 0
  br i1 %12, label %52, label %13

13:                                               ; preds = %8
  %14 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %9, i64 0, i32 5, i64 0, i32 2, i64 0
  %15 = tail call i32 @strcmp(i8* noundef nonnull %14, i8* noundef nonnull dereferenceable(1) %0) #14
  %16 = icmp eq i32 %15, 0
  br i1 %16, label %17, label %52

17:                                               ; preds = %160, %152, %144, %136, %128, %120, %112, %104, %96, %88, %80, %72, %64, %56, %13
  %18 = phi i64 [ 0, %13 ], [ 1, %56 ], [ 2, %64 ], [ 3, %72 ], [ 4, %80 ], [ 5, %88 ], [ 6, %96 ], [ 7, %104 ], [ 8, %112 ], [ 9, %120 ], [ 10, %128 ], [ 11, %136 ], [ 12, %144 ], [ 13, %152 ], [ 14, %160 ]
  %19 = phi i32* [ %10, %13 ], [ %53, %56 ], [ %61, %64 ], [ %69, %72 ], [ %77, %80 ], [ %85, %88 ], [ %93, %96 ], [ %101, %104 ], [ %109, %112 ], [ %117, %120 ], [ %125, %128 ], [ %133, %136 ], [ %141, %144 ], [ %149, %152 ], [ %157, %160 ]
  %20 = phi i32 [ %11, %13 ], [ %54, %56 ], [ %62, %64 ], [ %70, %72 ], [ %78, %80 ], [ %86, %88 ], [ %94, %96 ], [ %102, %104 ], [ %110, %112 ], [ %118, %120 ], [ %126, %128 ], [ %134, %136 ], [ %142, %144 ], [ %150, %152 ], [ %158, %160 ]
  %21 = getelementptr inbounds [15 x %struct.sfs_mem_file_t*], [15 x %struct.sfs_mem_file_t*]* @openFileTable, i64 0, i64 %18
  %22 = load %struct.sfs_mem_file_t*, %struct.sfs_mem_file_t** %21, align 8, !tbaa !18
  %23 = icmp eq %struct.sfs_mem_file_t* %22, null
  br i1 %23, label %24, label %164

24:                                               ; preds = %17
  store i32 0, i32* %19, align 4, !tbaa !5
  %25 = tail call %struct.sfs_filesystem_t* @accessSuperBlock() #15
  %26 = tail call %struct.sfs_block_hdr_t* @accessBlock(i32 noundef %20) #15
  %27 = getelementptr inbounds %struct.sfs_block_hdr_t, %struct.sfs_block_hdr_t* %26, i64 0, i32 1
  %28 = load i32, i32* %27, align 4, !tbaa !14
  %29 = icmp eq i32 %28, 0
  br i1 %29, label %33, label %30

30:                                               ; preds = %24
  %31 = tail call %struct.sfs_block_hdr_t* @accessBlock(i32 noundef %28) #15
  %32 = getelementptr inbounds %struct.sfs_block_hdr_t, %struct.sfs_block_hdr_t* %31, i64 0, i32 2
  store i32 0, i32* %32, align 4, !tbaa !12
  store i32 0, i32* %27, align 4, !tbaa !14
  br label %33

33:                                               ; preds = %30, %24
  %34 = getelementptr inbounds %struct.sfs_block_hdr_t, %struct.sfs_block_hdr_t* %26, i64 0, i32 0, i64 0
  %35 = tail call i32 @bcmp(i8* noundef nonnull dereferenceable(4) %34, i8* noundef nonnull dereferenceable(4) getelementptr inbounds ([5 x i8], [5 x i8]* @.str.8, i64 0, i64 0), i64 4) #15
  %36 = icmp eq i32 %35, 0
  br i1 %36, label %37, label %38

37:                                               ; preds = %43, %33
  tail call void @__assert_fail(i8* noundef getelementptr inbounds ([58 x i8], [58 x i8]* @.str.9, i64 0, i64 0), i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str.1, i64 0, i64 0), i32 noundef 188, i8* noundef getelementptr inbounds ([26 x i8], [26 x i8]* @__PRETTY_FUNCTION__.freeBlocks, i64 0, i64 0)) #16
  unreachable

38:                                               ; preds = %33, %43
  %39 = phi %struct.sfs_block_hdr_t* [ %44, %43 ], [ %26, %33 ]
  tail call void @setBlockType(%struct.sfs_block_hdr_t* noundef %39, i8* noundef getelementptr inbounds ([5 x i8], [5 x i8]* @.str.8, i64 0, i64 0)) #15
  %40 = getelementptr inbounds %struct.sfs_block_hdr_t, %struct.sfs_block_hdr_t* %39, i64 0, i32 2
  %41 = load i32, i32* %40, align 4, !tbaa !12
  %42 = icmp eq i32 %41, 0
  br i1 %42, label %48, label %43

43:                                               ; preds = %38
  %44 = tail call %struct.sfs_block_hdr_t* @accessBlock(i32 noundef %41) #15
  %45 = getelementptr inbounds %struct.sfs_block_hdr_t, %struct.sfs_block_hdr_t* %44, i64 0, i32 0, i64 0
  %46 = tail call i32 @bcmp(i8* noundef nonnull dereferenceable(4) %45, i8* noundef nonnull dereferenceable(4) getelementptr inbounds ([5 x i8], [5 x i8]* @.str.8, i64 0, i64 0), i64 4) #15
  %47 = icmp eq i32 %46, 0
  br i1 %47, label %37, label %38

48:                                               ; preds = %38
  %49 = getelementptr inbounds %struct.sfs_block_hdr_t, %struct.sfs_block_hdr_t* %39, i64 0, i32 2
  %50 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %25, i64 0, i32 2
  %51 = load i32, i32* %50, align 4, !tbaa !10
  store i32 %51, i32* %49, align 4, !tbaa !12
  store i32 %20, i32* %50, align 4, !tbaa !10
  br label %164

52:                                               ; preds = %8, %13
  %53 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %9, i64 0, i32 5, i64 1, i32 0
  %54 = load i32, i32* %53, align 4, !tbaa !5
  %55 = icmp eq i32 %54, 0
  br i1 %55, label %60, label %56

56:                                               ; preds = %52
  %57 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %9, i64 0, i32 5, i64 1, i32 2, i64 0
  %58 = tail call i32 @strcmp(i8* noundef nonnull %57, i8* noundef nonnull dereferenceable(1) %0) #14
  %59 = icmp eq i32 %58, 0
  br i1 %59, label %17, label %60

60:                                               ; preds = %56, %52
  %61 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %9, i64 0, i32 5, i64 2, i32 0
  %62 = load i32, i32* %61, align 4, !tbaa !5
  %63 = icmp eq i32 %62, 0
  br i1 %63, label %68, label %64

64:                                               ; preds = %60
  %65 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %9, i64 0, i32 5, i64 2, i32 2, i64 0
  %66 = tail call i32 @strcmp(i8* noundef nonnull %65, i8* noundef nonnull dereferenceable(1) %0) #14
  %67 = icmp eq i32 %66, 0
  br i1 %67, label %17, label %68

68:                                               ; preds = %64, %60
  %69 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %9, i64 0, i32 5, i64 3, i32 0
  %70 = load i32, i32* %69, align 4, !tbaa !5
  %71 = icmp eq i32 %70, 0
  br i1 %71, label %76, label %72

72:                                               ; preds = %68
  %73 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %9, i64 0, i32 5, i64 3, i32 2, i64 0
  %74 = tail call i32 @strcmp(i8* noundef nonnull %73, i8* noundef nonnull dereferenceable(1) %0) #14
  %75 = icmp eq i32 %74, 0
  br i1 %75, label %17, label %76

76:                                               ; preds = %72, %68
  %77 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %9, i64 0, i32 5, i64 4, i32 0
  %78 = load i32, i32* %77, align 4, !tbaa !5
  %79 = icmp eq i32 %78, 0
  br i1 %79, label %84, label %80

80:                                               ; preds = %76
  %81 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %9, i64 0, i32 5, i64 4, i32 2, i64 0
  %82 = tail call i32 @strcmp(i8* noundef nonnull %81, i8* noundef nonnull dereferenceable(1) %0) #14
  %83 = icmp eq i32 %82, 0
  br i1 %83, label %17, label %84

84:                                               ; preds = %80, %76
  %85 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %9, i64 0, i32 5, i64 5, i32 0
  %86 = load i32, i32* %85, align 4, !tbaa !5
  %87 = icmp eq i32 %86, 0
  br i1 %87, label %92, label %88

88:                                               ; preds = %84
  %89 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %9, i64 0, i32 5, i64 5, i32 2, i64 0
  %90 = tail call i32 @strcmp(i8* noundef nonnull %89, i8* noundef nonnull dereferenceable(1) %0) #14
  %91 = icmp eq i32 %90, 0
  br i1 %91, label %17, label %92

92:                                               ; preds = %88, %84
  %93 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %9, i64 0, i32 5, i64 6, i32 0
  %94 = load i32, i32* %93, align 4, !tbaa !5
  %95 = icmp eq i32 %94, 0
  br i1 %95, label %100, label %96

96:                                               ; preds = %92
  %97 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %9, i64 0, i32 5, i64 6, i32 2, i64 0
  %98 = tail call i32 @strcmp(i8* noundef nonnull %97, i8* noundef nonnull dereferenceable(1) %0) #14
  %99 = icmp eq i32 %98, 0
  br i1 %99, label %17, label %100

100:                                              ; preds = %96, %92
  %101 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %9, i64 0, i32 5, i64 7, i32 0
  %102 = load i32, i32* %101, align 4, !tbaa !5
  %103 = icmp eq i32 %102, 0
  br i1 %103, label %108, label %104

104:                                              ; preds = %100
  %105 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %9, i64 0, i32 5, i64 7, i32 2, i64 0
  %106 = tail call i32 @strcmp(i8* noundef nonnull %105, i8* noundef nonnull dereferenceable(1) %0) #14
  %107 = icmp eq i32 %106, 0
  br i1 %107, label %17, label %108

108:                                              ; preds = %104, %100
  %109 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %9, i64 0, i32 5, i64 8, i32 0
  %110 = load i32, i32* %109, align 4, !tbaa !5
  %111 = icmp eq i32 %110, 0
  br i1 %111, label %116, label %112

112:                                              ; preds = %108
  %113 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %9, i64 0, i32 5, i64 8, i32 2, i64 0
  %114 = tail call i32 @strcmp(i8* noundef nonnull %113, i8* noundef nonnull dereferenceable(1) %0) #14
  %115 = icmp eq i32 %114, 0
  br i1 %115, label %17, label %116

116:                                              ; preds = %112, %108
  %117 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %9, i64 0, i32 5, i64 9, i32 0
  %118 = load i32, i32* %117, align 4, !tbaa !5
  %119 = icmp eq i32 %118, 0
  br i1 %119, label %124, label %120

120:                                              ; preds = %116
  %121 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %9, i64 0, i32 5, i64 9, i32 2, i64 0
  %122 = tail call i32 @strcmp(i8* noundef nonnull %121, i8* noundef nonnull dereferenceable(1) %0) #14
  %123 = icmp eq i32 %122, 0
  br i1 %123, label %17, label %124

124:                                              ; preds = %120, %116
  %125 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %9, i64 0, i32 5, i64 10, i32 0
  %126 = load i32, i32* %125, align 4, !tbaa !5
  %127 = icmp eq i32 %126, 0
  br i1 %127, label %132, label %128

128:                                              ; preds = %124
  %129 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %9, i64 0, i32 5, i64 10, i32 2, i64 0
  %130 = tail call i32 @strcmp(i8* noundef nonnull %129, i8* noundef nonnull dereferenceable(1) %0) #14
  %131 = icmp eq i32 %130, 0
  br i1 %131, label %17, label %132

132:                                              ; preds = %128, %124
  %133 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %9, i64 0, i32 5, i64 11, i32 0
  %134 = load i32, i32* %133, align 4, !tbaa !5
  %135 = icmp eq i32 %134, 0
  br i1 %135, label %140, label %136

136:                                              ; preds = %132
  %137 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %9, i64 0, i32 5, i64 11, i32 2, i64 0
  %138 = tail call i32 @strcmp(i8* noundef nonnull %137, i8* noundef nonnull dereferenceable(1) %0) #14
  %139 = icmp eq i32 %138, 0
  br i1 %139, label %17, label %140

140:                                              ; preds = %136, %132
  %141 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %9, i64 0, i32 5, i64 12, i32 0
  %142 = load i32, i32* %141, align 4, !tbaa !5
  %143 = icmp eq i32 %142, 0
  br i1 %143, label %148, label %144

144:                                              ; preds = %140
  %145 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %9, i64 0, i32 5, i64 12, i32 2, i64 0
  %146 = tail call i32 @strcmp(i8* noundef nonnull %145, i8* noundef nonnull dereferenceable(1) %0) #14
  %147 = icmp eq i32 %146, 0
  br i1 %147, label %17, label %148

148:                                              ; preds = %144, %140
  %149 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %9, i64 0, i32 5, i64 13, i32 0
  %150 = load i32, i32* %149, align 4, !tbaa !5
  %151 = icmp eq i32 %150, 0
  br i1 %151, label %156, label %152

152:                                              ; preds = %148
  %153 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %9, i64 0, i32 5, i64 13, i32 2, i64 0
  %154 = tail call i32 @strcmp(i8* noundef nonnull %153, i8* noundef nonnull dereferenceable(1) %0) #14
  %155 = icmp eq i32 %154, 0
  br i1 %155, label %17, label %156

156:                                              ; preds = %152, %148
  %157 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %9, i64 0, i32 5, i64 14, i32 0
  %158 = load i32, i32* %157, align 4, !tbaa !5
  %159 = icmp eq i32 %158, 0
  br i1 %159, label %164, label %160

160:                                              ; preds = %156
  %161 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %9, i64 0, i32 5, i64 14, i32 2, i64 0
  %162 = tail call i32 @strcmp(i8* noundef nonnull %161, i8* noundef nonnull dereferenceable(1) %0) #14
  %163 = icmp eq i32 %162, 0
  br i1 %163, label %17, label %164

164:                                              ; preds = %156, %160, %17, %48, %5, %1
  %165 = phi i32 [ -36, %1 ], [ -123, %5 ], [ -16, %17 ], [ 0, %48 ], [ -2, %160 ], [ -2, %156 ]
  ret i32 %165
}

; Function Attrs: argmemonly mustprogress nofree nounwind readonly willreturn
declare i64 @strlen(i8* nocapture noundef) local_unnamed_addr #1

; Function Attrs: nounwind uwtable
define dso_local i32 @sfs_rename(i8* nocapture noundef readonly %0, i8* nocapture noundef readonly %1) local_unnamed_addr #0 {
  %3 = tail call i64 @strlen(i8* noundef nonnull dereferenceable(1) %0) #14
  %4 = add i64 %3, -24
  %5 = icmp ult i64 %4, -25
  br i1 %5, label %262, label %6

6:                                                ; preds = %2
  %7 = tail call i64 @strlen(i8* noundef nonnull dereferenceable(1) %1) #14
  %8 = add i64 %7, -24
  %9 = icmp ult i64 %8, -25
  br i1 %9, label %262, label %10

10:                                               ; preds = %6
  %11 = tail call i32 @getSFSStatus() #15
  %12 = icmp slt i32 %11, 0
  br i1 %12, label %262, label %13

13:                                               ; preds = %10
  %14 = tail call %struct.sfs_filesystem_t* @accessSuperBlock() #15
  %15 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 0, i32 0
  %16 = load i32, i32* %15, align 4, !tbaa !5
  %17 = icmp eq i32 %16, 0
  br i1 %17, label %24, label %18

18:                                               ; preds = %13
  %19 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 0, i32 2, i64 0
  %20 = tail call i32 @strcmp(i8* noundef nonnull %19, i8* noundef nonnull dereferenceable(1) %0) #14
  %21 = icmp eq i32 %20, 0
  br i1 %21, label %136, label %24

22:                                               ; preds = %132, %124, %116, %108, %100, %92, %84, %76, %68, %60, %52, %44, %36, %28
  %23 = phi i64 [ 1, %28 ], [ 2, %36 ], [ 3, %44 ], [ 4, %52 ], [ 5, %60 ], [ 6, %68 ], [ 7, %76 ], [ 8, %84 ], [ 9, %92 ], [ 10, %100 ], [ 11, %108 ], [ 12, %116 ], [ 13, %124 ], [ 14, %132 ]
  br i1 %17, label %144, label %136

24:                                               ; preds = %13, %18
  %25 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 1, i32 0
  %26 = load i32, i32* %25, align 4, !tbaa !5
  %27 = icmp eq i32 %26, 0
  br i1 %27, label %32, label %28

28:                                               ; preds = %24
  %29 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 1, i32 2, i64 0
  %30 = tail call i32 @strcmp(i8* noundef nonnull %29, i8* noundef nonnull dereferenceable(1) %0) #14
  %31 = icmp eq i32 %30, 0
  br i1 %31, label %22, label %32

32:                                               ; preds = %28, %24
  %33 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 2, i32 0
  %34 = load i32, i32* %33, align 4, !tbaa !5
  %35 = icmp eq i32 %34, 0
  br i1 %35, label %40, label %36

36:                                               ; preds = %32
  %37 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 2, i32 2, i64 0
  %38 = tail call i32 @strcmp(i8* noundef nonnull %37, i8* noundef nonnull dereferenceable(1) %0) #14
  %39 = icmp eq i32 %38, 0
  br i1 %39, label %22, label %40

40:                                               ; preds = %36, %32
  %41 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 3, i32 0
  %42 = load i32, i32* %41, align 4, !tbaa !5
  %43 = icmp eq i32 %42, 0
  br i1 %43, label %48, label %44

44:                                               ; preds = %40
  %45 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 3, i32 2, i64 0
  %46 = tail call i32 @strcmp(i8* noundef nonnull %45, i8* noundef nonnull dereferenceable(1) %0) #14
  %47 = icmp eq i32 %46, 0
  br i1 %47, label %22, label %48

48:                                               ; preds = %44, %40
  %49 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 4, i32 0
  %50 = load i32, i32* %49, align 4, !tbaa !5
  %51 = icmp eq i32 %50, 0
  br i1 %51, label %56, label %52

52:                                               ; preds = %48
  %53 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 4, i32 2, i64 0
  %54 = tail call i32 @strcmp(i8* noundef nonnull %53, i8* noundef nonnull dereferenceable(1) %0) #14
  %55 = icmp eq i32 %54, 0
  br i1 %55, label %22, label %56

56:                                               ; preds = %52, %48
  %57 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 5, i32 0
  %58 = load i32, i32* %57, align 4, !tbaa !5
  %59 = icmp eq i32 %58, 0
  br i1 %59, label %64, label %60

60:                                               ; preds = %56
  %61 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 5, i32 2, i64 0
  %62 = tail call i32 @strcmp(i8* noundef nonnull %61, i8* noundef nonnull dereferenceable(1) %0) #14
  %63 = icmp eq i32 %62, 0
  br i1 %63, label %22, label %64

64:                                               ; preds = %60, %56
  %65 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 6, i32 0
  %66 = load i32, i32* %65, align 4, !tbaa !5
  %67 = icmp eq i32 %66, 0
  br i1 %67, label %72, label %68

68:                                               ; preds = %64
  %69 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 6, i32 2, i64 0
  %70 = tail call i32 @strcmp(i8* noundef nonnull %69, i8* noundef nonnull dereferenceable(1) %0) #14
  %71 = icmp eq i32 %70, 0
  br i1 %71, label %22, label %72

72:                                               ; preds = %68, %64
  %73 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 7, i32 0
  %74 = load i32, i32* %73, align 4, !tbaa !5
  %75 = icmp eq i32 %74, 0
  br i1 %75, label %80, label %76

76:                                               ; preds = %72
  %77 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 7, i32 2, i64 0
  %78 = tail call i32 @strcmp(i8* noundef nonnull %77, i8* noundef nonnull dereferenceable(1) %0) #14
  %79 = icmp eq i32 %78, 0
  br i1 %79, label %22, label %80

80:                                               ; preds = %76, %72
  %81 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 8, i32 0
  %82 = load i32, i32* %81, align 4, !tbaa !5
  %83 = icmp eq i32 %82, 0
  br i1 %83, label %88, label %84

84:                                               ; preds = %80
  %85 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 8, i32 2, i64 0
  %86 = tail call i32 @strcmp(i8* noundef nonnull %85, i8* noundef nonnull dereferenceable(1) %0) #14
  %87 = icmp eq i32 %86, 0
  br i1 %87, label %22, label %88

88:                                               ; preds = %84, %80
  %89 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 9, i32 0
  %90 = load i32, i32* %89, align 4, !tbaa !5
  %91 = icmp eq i32 %90, 0
  br i1 %91, label %96, label %92

92:                                               ; preds = %88
  %93 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 9, i32 2, i64 0
  %94 = tail call i32 @strcmp(i8* noundef nonnull %93, i8* noundef nonnull dereferenceable(1) %0) #14
  %95 = icmp eq i32 %94, 0
  br i1 %95, label %22, label %96

96:                                               ; preds = %92, %88
  %97 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 10, i32 0
  %98 = load i32, i32* %97, align 4, !tbaa !5
  %99 = icmp eq i32 %98, 0
  br i1 %99, label %104, label %100

100:                                              ; preds = %96
  %101 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 10, i32 2, i64 0
  %102 = tail call i32 @strcmp(i8* noundef nonnull %101, i8* noundef nonnull dereferenceable(1) %0) #14
  %103 = icmp eq i32 %102, 0
  br i1 %103, label %22, label %104

104:                                              ; preds = %100, %96
  %105 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 11, i32 0
  %106 = load i32, i32* %105, align 4, !tbaa !5
  %107 = icmp eq i32 %106, 0
  br i1 %107, label %112, label %108

108:                                              ; preds = %104
  %109 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 11, i32 2, i64 0
  %110 = tail call i32 @strcmp(i8* noundef nonnull %109, i8* noundef nonnull dereferenceable(1) %0) #14
  %111 = icmp eq i32 %110, 0
  br i1 %111, label %22, label %112

112:                                              ; preds = %108, %104
  %113 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 12, i32 0
  %114 = load i32, i32* %113, align 4, !tbaa !5
  %115 = icmp eq i32 %114, 0
  br i1 %115, label %120, label %116

116:                                              ; preds = %112
  %117 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 12, i32 2, i64 0
  %118 = tail call i32 @strcmp(i8* noundef nonnull %117, i8* noundef nonnull dereferenceable(1) %0) #14
  %119 = icmp eq i32 %118, 0
  br i1 %119, label %22, label %120

120:                                              ; preds = %116, %112
  %121 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 13, i32 0
  %122 = load i32, i32* %121, align 4, !tbaa !5
  %123 = icmp eq i32 %122, 0
  br i1 %123, label %128, label %124

124:                                              ; preds = %120
  %125 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 13, i32 2, i64 0
  %126 = tail call i32 @strcmp(i8* noundef nonnull %125, i8* noundef nonnull dereferenceable(1) %0) #14
  %127 = icmp eq i32 %126, 0
  br i1 %127, label %22, label %128

128:                                              ; preds = %124, %120
  %129 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 14, i32 0
  %130 = load i32, i32* %129, align 4, !tbaa !5
  %131 = icmp eq i32 %130, 0
  br i1 %131, label %262, label %132

132:                                              ; preds = %128
  %133 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 14, i32 2, i64 0
  %134 = tail call i32 @strcmp(i8* noundef nonnull %133, i8* noundef nonnull dereferenceable(1) %0) #14
  %135 = icmp eq i32 %134, 0
  br i1 %135, label %22, label %262

136:                                              ; preds = %18, %22
  %137 = phi i64 [ %23, %22 ], [ 0, %18 ]
  %138 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 0, i32 2, i64 0
  %139 = tail call i32 @strcmp(i8* noundef nonnull %138, i8* noundef nonnull dereferenceable(1) %1) #14
  %140 = icmp eq i32 %139, 0
  br i1 %140, label %141, label %144

141:                                              ; preds = %253, %245, %237, %229, %221, %213, %205, %197, %189, %181, %173, %165, %157, %149, %136
  %142 = phi i64 [ %145, %253 ], [ %145, %245 ], [ %145, %237 ], [ %145, %229 ], [ %145, %221 ], [ %145, %213 ], [ %145, %205 ], [ %145, %197 ], [ %145, %189 ], [ %145, %181 ], [ %145, %173 ], [ %145, %165 ], [ %145, %157 ], [ %145, %149 ], [ %137, %136 ]
  %143 = tail call i32 @sfs_remove(i8* noundef %1)
  br label %257

144:                                              ; preds = %22, %136
  %145 = phi i64 [ %23, %22 ], [ %137, %136 ]
  %146 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 1, i32 0
  %147 = load i32, i32* %146, align 4, !tbaa !5
  %148 = icmp eq i32 %147, 0
  br i1 %148, label %153, label %149

149:                                              ; preds = %144
  %150 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 1, i32 2, i64 0
  %151 = tail call i32 @strcmp(i8* noundef nonnull %150, i8* noundef nonnull dereferenceable(1) %1) #14
  %152 = icmp eq i32 %151, 0
  br i1 %152, label %141, label %153

153:                                              ; preds = %149, %144
  %154 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 2, i32 0
  %155 = load i32, i32* %154, align 4, !tbaa !5
  %156 = icmp eq i32 %155, 0
  br i1 %156, label %161, label %157

157:                                              ; preds = %153
  %158 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 2, i32 2, i64 0
  %159 = tail call i32 @strcmp(i8* noundef nonnull %158, i8* noundef nonnull dereferenceable(1) %1) #14
  %160 = icmp eq i32 %159, 0
  br i1 %160, label %141, label %161

161:                                              ; preds = %157, %153
  %162 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 3, i32 0
  %163 = load i32, i32* %162, align 4, !tbaa !5
  %164 = icmp eq i32 %163, 0
  br i1 %164, label %169, label %165

165:                                              ; preds = %161
  %166 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 3, i32 2, i64 0
  %167 = tail call i32 @strcmp(i8* noundef nonnull %166, i8* noundef nonnull dereferenceable(1) %1) #14
  %168 = icmp eq i32 %167, 0
  br i1 %168, label %141, label %169

169:                                              ; preds = %165, %161
  %170 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 4, i32 0
  %171 = load i32, i32* %170, align 4, !tbaa !5
  %172 = icmp eq i32 %171, 0
  br i1 %172, label %177, label %173

173:                                              ; preds = %169
  %174 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 4, i32 2, i64 0
  %175 = tail call i32 @strcmp(i8* noundef nonnull %174, i8* noundef nonnull dereferenceable(1) %1) #14
  %176 = icmp eq i32 %175, 0
  br i1 %176, label %141, label %177

177:                                              ; preds = %173, %169
  %178 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 5, i32 0
  %179 = load i32, i32* %178, align 4, !tbaa !5
  %180 = icmp eq i32 %179, 0
  br i1 %180, label %185, label %181

181:                                              ; preds = %177
  %182 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 5, i32 2, i64 0
  %183 = tail call i32 @strcmp(i8* noundef nonnull %182, i8* noundef nonnull dereferenceable(1) %1) #14
  %184 = icmp eq i32 %183, 0
  br i1 %184, label %141, label %185

185:                                              ; preds = %181, %177
  %186 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 6, i32 0
  %187 = load i32, i32* %186, align 4, !tbaa !5
  %188 = icmp eq i32 %187, 0
  br i1 %188, label %193, label %189

189:                                              ; preds = %185
  %190 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 6, i32 2, i64 0
  %191 = tail call i32 @strcmp(i8* noundef nonnull %190, i8* noundef nonnull dereferenceable(1) %1) #14
  %192 = icmp eq i32 %191, 0
  br i1 %192, label %141, label %193

193:                                              ; preds = %189, %185
  %194 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 7, i32 0
  %195 = load i32, i32* %194, align 4, !tbaa !5
  %196 = icmp eq i32 %195, 0
  br i1 %196, label %201, label %197

197:                                              ; preds = %193
  %198 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 7, i32 2, i64 0
  %199 = tail call i32 @strcmp(i8* noundef nonnull %198, i8* noundef nonnull dereferenceable(1) %1) #14
  %200 = icmp eq i32 %199, 0
  br i1 %200, label %141, label %201

201:                                              ; preds = %197, %193
  %202 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 8, i32 0
  %203 = load i32, i32* %202, align 4, !tbaa !5
  %204 = icmp eq i32 %203, 0
  br i1 %204, label %209, label %205

205:                                              ; preds = %201
  %206 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 8, i32 2, i64 0
  %207 = tail call i32 @strcmp(i8* noundef nonnull %206, i8* noundef nonnull dereferenceable(1) %1) #14
  %208 = icmp eq i32 %207, 0
  br i1 %208, label %141, label %209

209:                                              ; preds = %205, %201
  %210 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 9, i32 0
  %211 = load i32, i32* %210, align 4, !tbaa !5
  %212 = icmp eq i32 %211, 0
  br i1 %212, label %217, label %213

213:                                              ; preds = %209
  %214 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 9, i32 2, i64 0
  %215 = tail call i32 @strcmp(i8* noundef nonnull %214, i8* noundef nonnull dereferenceable(1) %1) #14
  %216 = icmp eq i32 %215, 0
  br i1 %216, label %141, label %217

217:                                              ; preds = %213, %209
  %218 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 10, i32 0
  %219 = load i32, i32* %218, align 4, !tbaa !5
  %220 = icmp eq i32 %219, 0
  br i1 %220, label %225, label %221

221:                                              ; preds = %217
  %222 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 10, i32 2, i64 0
  %223 = tail call i32 @strcmp(i8* noundef nonnull %222, i8* noundef nonnull dereferenceable(1) %1) #14
  %224 = icmp eq i32 %223, 0
  br i1 %224, label %141, label %225

225:                                              ; preds = %221, %217
  %226 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 11, i32 0
  %227 = load i32, i32* %226, align 4, !tbaa !5
  %228 = icmp eq i32 %227, 0
  br i1 %228, label %233, label %229

229:                                              ; preds = %225
  %230 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 11, i32 2, i64 0
  %231 = tail call i32 @strcmp(i8* noundef nonnull %230, i8* noundef nonnull dereferenceable(1) %1) #14
  %232 = icmp eq i32 %231, 0
  br i1 %232, label %141, label %233

233:                                              ; preds = %229, %225
  %234 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 12, i32 0
  %235 = load i32, i32* %234, align 4, !tbaa !5
  %236 = icmp eq i32 %235, 0
  br i1 %236, label %241, label %237

237:                                              ; preds = %233
  %238 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 12, i32 2, i64 0
  %239 = tail call i32 @strcmp(i8* noundef nonnull %238, i8* noundef nonnull dereferenceable(1) %1) #14
  %240 = icmp eq i32 %239, 0
  br i1 %240, label %141, label %241

241:                                              ; preds = %237, %233
  %242 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 13, i32 0
  %243 = load i32, i32* %242, align 4, !tbaa !5
  %244 = icmp eq i32 %243, 0
  br i1 %244, label %249, label %245

245:                                              ; preds = %241
  %246 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 13, i32 2, i64 0
  %247 = tail call i32 @strcmp(i8* noundef nonnull %246, i8* noundef nonnull dereferenceable(1) %1) #14
  %248 = icmp eq i32 %247, 0
  br i1 %248, label %141, label %249

249:                                              ; preds = %245, %241
  %250 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 14, i32 0
  %251 = load i32, i32* %250, align 4, !tbaa !5
  %252 = icmp eq i32 %251, 0
  br i1 %252, label %257, label %253

253:                                              ; preds = %249
  %254 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 14, i32 2, i64 0
  %255 = tail call i32 @strcmp(i8* noundef nonnull %254, i8* noundef nonnull dereferenceable(1) %1) #14
  %256 = icmp eq i32 %255, 0
  br i1 %256, label %141, label %257

257:                                              ; preds = %249, %253, %141
  %258 = phi i64 [ %142, %141 ], [ %145, %253 ], [ %145, %249 ]
  %259 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 %258, i32 2, i64 0
  %260 = tail call i8* @strncpy(i8* noundef nonnull %259, i8* noundef nonnull dereferenceable(1) %1, i64 noundef 23) #15
  %261 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %14, i64 0, i32 5, i64 %258, i32 2, i64 23
  store i8 0, i8* %261, align 1, !tbaa !34
  br label %262

262:                                              ; preds = %128, %132, %257, %10, %2, %6
  %263 = phi i32 [ -36, %6 ], [ -36, %2 ], [ -123, %10 ], [ 0, %257 ], [ -2, %132 ], [ -2, %128 ]
  ret i32 %263
}

; Function Attrs: argmemonly mustprogress nofree nounwind willreturn
declare i8* @strncpy(i8* noalias noundef returned writeonly, i8* noalias nocapture noundef readonly, i64 noundef) local_unnamed_addr #10

; Function Attrs: nounwind uwtable
define dso_local i32 @sfs_list(i8** nocapture noundef %0, i8* nocapture noundef writeonly %1, i64 noundef %2) local_unnamed_addr #0 {
  %4 = icmp eq i64 %2, 0
  br i1 %4, label %33, label %5

5:                                                ; preds = %3
  %6 = tail call i32 @getSFSStatus() #15
  %7 = icmp slt i32 %6, 0
  br i1 %7, label %33, label %8

8:                                                ; preds = %5
  %9 = load i8*, i8** %0, align 8, !tbaa !18
  %10 = tail call %struct.sfs_filesystem_t* @accessSuperBlock() #15
  %11 = icmp ult i8* %9, inttoptr (i64 15 to i8*)
  br i1 %11, label %12, label %30

12:                                               ; preds = %8
  %13 = ptrtoint i8* %9 to i64
  br label %14

14:                                               ; preds = %12, %27
  %15 = phi i64 [ %28, %27 ], [ %13, %12 ]
  %16 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %10, i64 0, i32 5, i64 %15, i32 0
  %17 = load i32, i32* %16, align 4, !tbaa !5
  %18 = icmp eq i32 %17, 0
  br i1 %18, label %27, label %19

19:                                               ; preds = %14
  %20 = getelementptr inbounds %struct.sfs_filesystem_t, %struct.sfs_filesystem_t* %10, i64 0, i32 5, i64 %15, i32 2, i64 0
  %21 = tail call i64 @strlen(i8* noundef nonnull %20) #14
  %22 = add i64 %21, 1
  %23 = icmp ugt i64 %22, %2
  br i1 %23, label %33, label %24

24:                                               ; preds = %19
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %1, i8* nonnull align 4 %20, i64 %22, i1 false)
  %25 = add nuw nsw i64 %15, 1
  %26 = inttoptr i64 %25 to i8*
  br label %30

27:                                               ; preds = %14
  %28 = add nuw nsw i64 %15, 1
  %29 = icmp ult i64 %15, 14
  br i1 %29, label %14, label %30

30:                                               ; preds = %27, %8, %24
  %31 = phi i8* [ %26, %24 ], [ null, %8 ], [ null, %27 ]
  %32 = phi i32 [ 0, %24 ], [ 1, %8 ], [ 1, %27 ]
  store i8* %31, i8** %0, align 8, !tbaa !18
  br label %33

33:                                               ; preds = %30, %19, %5, %3
  %34 = phi i32 [ -22, %3 ], [ -123, %5 ], [ -36, %19 ], [ %32, %30 ]
  ret i32 %34
}

; Function Attrs: inaccessiblememonly mustprogress nofree nounwind willreturn
declare noalias noundef i8* @malloc(i64 noundef) local_unnamed_addr #11

; Function Attrs: argmemonly mustprogress nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #12

declare %struct.sfs_block_hdr_t* @accessFreeBlock(i32 noundef) local_unnamed_addr #2

declare void @setBlockType(%struct.sfs_block_hdr_t* noundef, i8* noundef) local_unnamed_addr #2

declare %struct.sfs_block_hdr_t* @accessBlock(i32 noundef) local_unnamed_addr #2

; Function Attrs: argmemonly nofree nounwind readonly willreturn
declare i32 @bcmp(i8* nocapture, i8* nocapture, i64) local_unnamed_addr #13

attributes #0 = { nounwind uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { argmemonly mustprogress nofree nounwind readonly willreturn "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { mustprogress nounwind uwtable willreturn "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { inaccessiblemem_or_argmemonly mustprogress nounwind willreturn "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nounwind "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { noreturn nounwind "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #7 = { argmemonly mustprogress nofree nounwind willreturn }
attributes #8 = { mustprogress nofree norecurse nosync nounwind readonly uwtable willreturn "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #9 = { mustprogress nofree norecurse nosync nounwind uwtable willreturn "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #10 = { argmemonly mustprogress nofree nounwind willreturn "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #11 = { inaccessiblememonly mustprogress nofree nounwind willreturn "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #12 = { argmemonly mustprogress nofree nounwind willreturn writeonly }
attributes #13 = { argmemonly nofree nounwind readonly willreturn }
attributes #14 = { nounwind readonly willreturn }
attributes #15 = { nounwind }
attributes #16 = { noreturn nounwind }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!5 = !{!6, !7, i64 0}
!6 = !{!"sfs_dir_entry_t", !7, i64 0, !7, i64 4, !8, i64 8}
!7 = !{!"int", !8, i64 0}
!8 = !{!"omnipotent char", !9, i64 0}
!9 = !{!"Simple C/C++ TBAA"}
!10 = !{!11, !7, i64 12}
!11 = !{!"sfs_filesystem_t", !8, i64 0, !7, i64 8, !7, i64 12, !7, i64 16, !8, i64 20, !8, i64 32}
!12 = !{!13, !7, i64 8}
!13 = !{!"sfs_block_hdr_t", !8, i64 0, !7, i64 4, !7, i64 8}
!14 = !{!13, !7, i64 4}
!15 = distinct !{!15, !16}
!16 = !{!"llvm.loop.mustprogress"}
!17 = !{!6, !7, i64 4}
!18 = !{!19, !19, i64 0}
!19 = !{!"any pointer", !8, i64 0}
!20 = !{!21, !7, i64 0}
!21 = !{!"sfs_mem_file_t", !7, i64 0, !7, i64 4, !19, i64 8}
!22 = !{!21, !19, i64 8}
!23 = !{!21, !7, i64 4}
!24 = !{!25, !19, i64 0}
!25 = !{!"sfs_mem_filedesc_t", !19, i64 0, !7, i64 8, !7, i64 12, !26, i64 16}
!26 = !{!"long", !8, i64 0}
!27 = !{!25, !7, i64 8}
!28 = !{!25, !7, i64 12}
!29 = !{!25, !26, i64 16}
!30 = !{!31, !7, i64 8}
!31 = !{!"sfs_block_file_t", !13, i64 0, !8, i64 12}
!32 = distinct !{!32, !16}
!33 = !{!31, !7, i64 4}
!34 = !{!8, !8, i64 0}
