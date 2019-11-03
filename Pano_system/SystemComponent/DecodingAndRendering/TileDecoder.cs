 /*
* This function is used to decode each small tile and output the corresponding YUV format frame.
* Input: Filename of the corresponding file name of the small tile and the corresponding index number of this tile.
*/

public unsafe void Decoder(string fileName, int tilenumber)
    {

        int error, frame_count = 0;
        int got_picture, ret;
        SwsContext* pSwsCtx = null;
        AVFormatContext* ofmt_ctx = null;
        IntPtr convertedFrameBufferPtr = IntPtr.Zero;
        show_flag = 1;
        try
        {
            // ע��������
            ffmpeg.avcodec_register_all();
            // ��ȡ�ļ���Ϣ�����ĳ�ʼ��
            ofmt_ctx = ffmpeg.avformat_alloc_context();


            // ��ý���ļ�
            error = ffmpeg.avformat_open_input(&ofmt_ctx, fileName, null, null);
            if (error != 0)
            {
                //  throw new ApplicationException(ffmpeg.FFmpegBinariesHelper.GetErrorMessage(error));
                Debug.Log(fileName);
                Debug.Log("��ʧ��");
                show_flag = 1;
                return 0;
            }

            // ��ȡ����ͨ��
            for (int i = 0; i < ofmt_ctx->nb_streams; i++)
            {
                if (ofmt_ctx->streams[i]->codec->codec_type == AVMediaType.AVMEDIA_TYPE_VIDEO)
                {
                    videoindex = i;
                    Debug.Log("video.............." + videoindex);
                }
            }

            if (videoindex == -1)
            {
                Debug.Log("Couldn't find a video stream.��û���ҵ���Ƶ����");
                return -1;
            }

            // ��Ƶ������
            if (videoindex > -1)
            {
                //��ȡ��Ƶ���еı����������
                AVCodecContext* pCodecCtx = ofmt_ctx->streams[videoindex]->codec;

                //���ݱ�����������еı���id���Ҷ�Ӧ�Ľ���
                AVCodec* pCodec = ffmpeg.avcodec_find_decoder(pCodecCtx->codec_id);
                if (pCodec == null)
                {
                    Debug.Log("û���ҵ�������");
                    show_flag = 2;
                    return -1;
                }

                //�򿪱�����
                if (ffmpeg.avcodec_open2(pCodecCtx, pCodec, null) < 0)
                {
                    Debug.Log("�������޷���");
                    show_flag = 3;
                    return -1;
                }

                Debug.Log("Find a  video stream.channel=" + videoindex);

                //�����Ƶ��Ϣ
                var format = ofmt_ctx->iformat->name->ToString();
                var len = (ofmt_ctx->duration) / 1000000;
                var width = pCodecCtx->width;
                var height = pCodecCtx->height;
                pCodecCtx->thread_count = 8;
                show_flag = 0;
                //׼����ȡ
                //AVPacket���ڴ洢һ֡һ֡��ѹ�����ݣ�H264��
                //�����������ٿռ�
                AVPacket* packet = (AVPacket*)ffmpeg.av_malloc((ulong)sizeof(AVPacket));

                //AVFrame���ڴ洢��������������(YUV)
                //�ڴ����
                AVFrame* pFrame = ffmpeg.av_frame_alloc();
                //YUV420
                AVFrame* pFrameYUV = ffmpeg.av_frame_alloc();
                //ֻ��ָ����AVFrame�����ظ�ʽ�������С�������������ڴ�
                //�����������ڴ�
                int out_buffer_size = ffmpeg.avpicture_get_size(AVPixelFormat.AV_PIX_FMT_YUV420P, pCodecCtx->width, pCodecCtx->height);
                byte* out_buffer = (byte*)ffmpeg.av_malloc((ulong)out_buffer_size);
                //��ʼ��������
                ffmpeg.avpicture_fill((AVPicture*)pFrameYUV, out_buffer, AVPixelFormat.AV_PIX_FMT_YUV420P, pCodecCtx->width, pCodecCtx->height);

                //����ת�루���ţ��Ĳ�����ת֮ǰ�Ŀ�ߣ�ת֮��Ŀ�ߣ���ʽ��
                SwsContext* sws_ctx = ffmpeg.sws_getContext(pCodecCtx->width, pCodecCtx->height, AVPixelFormat.AV_PIX_FMT_YUV420P /*pCodecCtx->pix_fmt*/, pCodecCtx->width, pCodecCtx->height, AVPixelFormat.AV_PIX_FMT_YUV420P, ffmpeg.SWS_BICUBIC, null, null, null);
                int flag = 0;
                int skipped_frame = 0; //�������ĩβ���벻��ȫ������

                while (ffmpeg.av_read_frame(ofmt_ctx, packet) >= 0)
                {
                    if (flag == 0)
                    {
                        semaphore[tilenumber].WaitOne();
                    }

                    //ֻҪ��Ƶѹ�����ݣ�������������λ���жϣ�
                    if (packet->stream_index == videoindex)
                    {
                        //����һ֡��Ƶѹ�����ݣ��õ���Ƶ��������
                        ret = ffmpeg.avcodec_decode_video2(pCodecCtx, pFrame, &got_picture, packet);
                        if (ret < 0)
                        {
                            Debug.Log("��Ƶ�������");
                            return -1;
                        }

                        Debug.Log("��ǰ����֡����" + skipped_frame.ToString());
                        // ��ȡ������֡����
                        if (got_picture > 0)
                        {
                            frame_count++;
                            Debug.Log("��Ƶ֡��:�� " + frame_count + " ֡");
                            //AVFrameתΪ���ظ�ʽYUV420�����
                            ffmpeg.sws_scale(sws_ctx, pFrame->data, pFrame->linesize, 0, pCodecCtx->height, pFrameYUV->data, pFrameYUV->linesize);                 
                            flag = 0;
                            cur[tilenumber] = pFrameYUV;
                            isTrue[tilenumber] = false; // ����ǰ֡��Ⱦ���
                        }
                        else
                        {
                           skipped_frame++;
                           flag = 1;
                        }
                        ffmpeg.av_free_packet(packet);
                    }
                    else
                    {
                        flag = 1;
                    }
  

                }
                
                flag = 0;
                for(int i = skipped_frame; i>0; i--)
                {
                    frame_count++;
                    if (flag == 0)
                    {
                        semaphore[tilenumber].WaitOne();
                    }
                    ret = ffmpeg.avcodec_decode_video2(pCodecCtx, pFrame, &got_picture, packet);
                    if (got_picture > 0)
                    {
                        
                        Debug.Log("��Ƶ֡��:�� " + frame_count + " ֡");
                        //AVFrameתΪ���ظ�ʽYUV420�����
                        ffmpeg.sws_scale(sws_ctx, pFrame->data, pFrame->linesize, 0, pCodecCtx->height, pFrameYUV->data, pFrameYUV->linesize);            
                        flag = 0;
                        cur[tilenumber] = pFrameYUV;
                        isTrue[tilenumber] = false; // ����ǰ֡��Ⱦ���
                    }
                    else
                    {
                        flag = 1;
                    }
                }
                Thread.Sleep(10);
                if (frame_count >= changeFrame) //�˳����Ų���
                {
                    semaphore[tilenumber].Release();
                    ffmpeg.av_free_packet(packet);
                    ffmpeg.avformat_close_input(&ofmt_ctx);
                    ffmpeg.av_frame_free(&pFrameYUV);
                    ffmpeg.av_frame_free(&pFrame);
                    ffmpeg.avcodec_close(pCodecCtx);
                    ffmpeg.av_free(out_buffer);
                    Debug.Log("��ǰ��Ƶ�������" + tilenumber.ToString());
                    return 0;
                }

            }

        }
        catch (Exception ex)
        {
            Debug.Log(ex);
            Thread.ResetAbort();
        }
        finally
        {
            if (&ofmt_ctx != null)
            {
                ffmpeg.avformat_close_input(&ofmt_ctx);//�ر����ļ� 
            }

        }
        IsRun = false;
        return 0;


    }