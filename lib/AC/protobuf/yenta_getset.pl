##
## This file was generated by Google::ProtocolBuffers (0.08)
## on Tue Jun 15 11:56:17 2010
##      
use strict;
use warnings;
use Google::ProtocolBuffers;
{       
    unless (ACPYentaMapDatum->can('_pb_fields_list')) {
        Google::ProtocolBuffers->create_message(
            'ACPYentaMapDatum',
            [
                [
                    Google::ProtocolBuffers::Constants::LABEL_REQUIRED(), 
                    Google::ProtocolBuffers::Constants::TYPE_STRING(), 
                    'map', 1, undef
                ],
                [
                    Google::ProtocolBuffers::Constants::LABEL_REQUIRED(), 
                    Google::ProtocolBuffers::Constants::TYPE_STRING(), 
                    'key', 2, undef
                ],
                [
                    Google::ProtocolBuffers::Constants::LABEL_OPTIONAL(), 
                    Google::ProtocolBuffers::Constants::TYPE_INT64(), 
                    'version', 3, undef
                ],
                [
                    Google::ProtocolBuffers::Constants::LABEL_OPTIONAL(), 
                    Google::ProtocolBuffers::Constants::TYPE_BYTES(), 
                    'value', 4, undef
                ],
                [
                    Google::ProtocolBuffers::Constants::LABEL_OPTIONAL(), 
                    Google::ProtocolBuffers::Constants::TYPE_BYTES(), 
                    'meta', 5, undef
                ],
                [
                    Google::ProtocolBuffers::Constants::LABEL_OPTIONAL(), 
                    Google::ProtocolBuffers::Constants::TYPE_BYTES(), 
                    'file', 6, undef
                ],
                [
                    Google::ProtocolBuffers::Constants::LABEL_OPTIONAL(), 
                    Google::ProtocolBuffers::Constants::TYPE_INT64(), 
                    'shard', 7, undef
                ],

            ],
            { 'create_accessors' => 1, 'follow_best_practice' => 1,  }
        );
    }

    unless (ACPYentaDistRequest->can('_pb_fields_list')) {
        Google::ProtocolBuffers->create_message(
            'ACPYentaDistRequest',
            [
                [
                    Google::ProtocolBuffers::Constants::LABEL_REQUIRED(), 
                    Google::ProtocolBuffers::Constants::TYPE_INT32(), 
                    'hop', 1, undef
                ],
                [
                    Google::ProtocolBuffers::Constants::LABEL_REQUIRED(), 
                    Google::ProtocolBuffers::Constants::TYPE_INT64(), 
                    'expire', 2, undef
                ],
                [
                    Google::ProtocolBuffers::Constants::LABEL_REQUIRED(), 
                    Google::ProtocolBuffers::Constants::TYPE_STRING(), 
                    'sender', 3, undef
                ],
                [
                    Google::ProtocolBuffers::Constants::LABEL_REQUIRED(), 
                    'ACPYentaMapDatum', 
                    'datum', 4, undef
                ],

            ],
            { 'create_accessors' => 1, 'follow_best_practice' => 1,  }
        );
    }

    unless (ACPYentaGetSet->can('_pb_fields_list')) {
        Google::ProtocolBuffers->create_message(
            'ACPYentaGetSet',
            [
                [
                    Google::ProtocolBuffers::Constants::LABEL_REPEATED(), 
                    'ACPYentaMapDatum', 
                    'data', 1, undef
                ],

            ],
            { 'create_accessors' => 1, 'follow_best_practice' => 1,  }
        );
    }

    unless (ACPYentaDistReply->can('_pb_fields_list')) {
        Google::ProtocolBuffers->create_message(
            'ACPYentaDistReply',
            [
                [
                    Google::ProtocolBuffers::Constants::LABEL_REQUIRED(), 
                    Google::ProtocolBuffers::Constants::TYPE_INT32(), 
                    'status_code', 1, undef
                ],
                [
                    Google::ProtocolBuffers::Constants::LABEL_REQUIRED(), 
                    Google::ProtocolBuffers::Constants::TYPE_STRING(), 
                    'status_message', 2, undef
                ],
                [
                    Google::ProtocolBuffers::Constants::LABEL_REQUIRED(), 
                    Google::ProtocolBuffers::Constants::TYPE_BOOL(), 
                    'haveit', 3, undef
                ],

            ],
            { 'create_accessors' => 1, 'follow_best_practice' => 1,  }
        );
    }

}
1;
